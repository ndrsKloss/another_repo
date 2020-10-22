import Foundation
import RxSwift

typealias TopStartSwiftResponse = (repositories: TopStarSwiftModel, nextURL: URL?)

final class TopStarSwiftRepository: TopStarSwiftFetchable {

	private let parser: WebLinkParseable
	private let repositoryOperation: RepositoryOperationScheduable
	
	init(
		parser: WebLinkParseable,
		repositoryOperation: RepositoryOperationScheduable
	) {
		self.parser = parser
		self.repositoryOperation = repositoryOperation
	}
	
	func fetchTopSwiftStarRepos(
		_ URL: URL?
	) -> Observable<TopStartSwiftResponse> {
		guard let URL = URL else { return .empty() }
		
		return URLSession.shared.rx
			.response(request: URLRequest(url: URL))
			.observeOn(repositoryOperation.scheduler)
			.map { [weak self] response -> TopStartSwiftResponse in
				let topStartSwiftModel = try JSONDecoder().decode(TopStarSwiftModel.self, from: response.data)
				let URL = try self?.parser.parse(response.0)
				return (repositories: topStartSwiftModel, nextURL: URL)
		}
	}
}
