import Foundation
import RxSwift

typealias TopStartSwiftResponse = Result<(repositories: TopStarSwiftModel, nextURL: URL?), TopStarSwiftRepositoryError>

struct TopStarSwiftRepository:
TopStarSwiftFetchable {
	
	func fetchTopSwiftStarRepos(
		_ URL: URL?
	) -> Observable<TopStartSwiftResponse> {
		guard let URL = URL else {
				return .empty()
		}
		
		let operationQueue = OperationQueue()
		operationQueue.maxConcurrentOperationCount = 2
		operationQueue.qualityOfService = QualityOfService.userInitiated
		
		return URLSession.shared.rx
			.response(request: URLRequest(url: URL))
			.observeOn(OperationQueueScheduler(operationQueue: operationQueue))
			.map { [parseNextURL] response -> TopStartSwiftResponse in
				
				if response.0.statusCode == 403 {
					return .failure(.githubLimitReached)
				}
				
				if !(200 ..< 300 ~= response.0.statusCode) {
					return .failure(.callFailed)
				}
				
				let topStartSwiftModel = try JSONDecoder().decode(TopStarSwiftModel.self, from: response.data)
				
				let nextURL = try parseNextURL(response.0)
				
				return .success((repositories: topStartSwiftModel, nextURL: nextURL))
		}
	}
}

/// Those set of functions serve to extract the direct next URL from the Link header.
/// It is part of the GitHub's Traversing with Pagination: https://developer.github.com/v3/guides/traversing-with-pagination/
/// More about Web Linking here: https://tools.ietf.org/html/rfc5988

extension TopStarSwiftRepository {
	
	private var parseLinksPattern: String {
		"\\s*,?\\s*<([^\\>]*)>\\s*;\\s*rel=\"([^\"]*)\""
	}
	
	private var linksRegex: NSRegularExpression? {
		try? NSRegularExpression(
			pattern: parseLinksPattern,
			options: [.allowCommentsAndWhitespace]
		)
	}
	
	private func parseNextURL(
		_ httpResponse: HTTPURLResponse?
	) throws -> URL? {
		guard let serializedLinks = httpResponse?.allHeaderFields["Link"] as? String else {
			return nil
		}
		
		let links = try parseLinks(serializedLinks)
		
		guard let nextPageURL = links["next"] else {
			return nil
		}
		
		guard let nextUrl = URL(string: nextPageURL) else {
			return nil
		}
		
		return nextUrl
	}
	
	private func parseLinks(
		_ links: String
	) throws -> [String: String] {
		
		let length = (links as NSString).length
		let matches = linksRegex?.matches(
			in: links,
			options: NSRegularExpression.MatchingOptions(),
			range: NSRange(location: 0, length: length)
		)
		
		var result: [String: String] = [:]
		
		guard let _matches = matches else {
			throw error("Error matching NSRegularExpression")
		}
		
		for m in _matches {
			let matches = (1 ..< m.numberOfRanges)
				.map { rangeIndex -> String in
					let range = m.range(at: rangeIndex)
					let startIndex = links.index(links.startIndex, offsetBy: range.location)
					let endIndex = links.index(links.startIndex, offsetBy: range.location + range.length)
					return String(links[startIndex ..< endIndex])
			}
			
			if matches.count != 2 {
				throw error("Error parsing links")
			}
			
			result[matches[1]] = matches[0]
		}
		
		return result
	}
}
