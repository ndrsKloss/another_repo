import Foundation
import RxSwift

final class AuthorImageRepository: AuthorImageFetchable {
	
	private let repositoryOperation: RepositoryOperationScheduable
	
	init(repositoryOperation: RepositoryOperationScheduable) {
		self.repositoryOperation = repositoryOperation
	}
	
	func fetchImage(
		_ URL: URL?
	) -> Observable<Data> {
		guard let URL = URL else { return .empty() }
		return URLSession.shared.rx
			.response(request: URLRequest(url: URL))
			.observeOn(repositoryOperation.scheduler)
			.map { $0.data }
	}
}
