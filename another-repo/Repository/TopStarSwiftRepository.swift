import Foundation
import RxSwift

typealias TopStartSwiftResponse = (repositories: TopStarSwiftModel, nextURL: URL?)

final class TopStarSwiftRepository:
TopStarSwiftFetchable,
RepositoryOperationScheduable {
	
	var scheduler: OperationQueueScheduler {
		let operationQueue = OperationQueue()
		operationQueue.maxConcurrentOperationCount = 1
		operationQueue.qualityOfService = QualityOfService.userInitiated
		return OperationQueueScheduler(operationQueue: operationQueue)
	}

	private let parser: WebLinkParseable
	
	init(parser: WebLinkParseable = NextURLParser()) {
		self.parser = parser
	}
	
	func fetchTopSwiftStarRepos(
		_ URL: URL?
	) -> Observable<TopStartSwiftResponse> {
		guard let URL = URL else { return .empty() }
		
		return URLSession.shared.rx
			.response(request: URLRequest(url: URL))
			.observeOn(scheduler)
			.map { [weak self] response -> TopStartSwiftResponse in
				let topStartSwiftModel = try JSONDecoder().decode(TopStarSwiftModel.self, from: response.data)
				let URL = try self?.parser.parse(response.0)
				return (repositories: topStartSwiftModel, nextURL: URL)
		}
	}
}
