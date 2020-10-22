import Foundation
import RxSwift

final class AuthorImageRepository: AuthorImageFetchable {
	
	private let repositoryOperation: RepositoryOperationScheduable
	private let cache: NaiveCachable
	private let disposeBag = DisposeBag()
	
	init(
		repositoryOperation: RepositoryOperationScheduable,
		cache: NaiveCachable = NaiveCache()
	) {
		self.repositoryOperation = repositoryOperation
		self.cache = cache
	}
	
	func fetchImage(
		_ URL: URL?
	) -> Observable<Data> {
		guard let URL = URL else { return .empty() }
		
		if let data = cache.load(key: URL.absoluteString) {
			return .just(data)
		}
		
		let response = URLSession.shared.rx
			.response(request: URLRequest(url: URL))
			.observeOn(repositoryOperation.scheduler)
		
		response
			.map { [cache, URL] in cache.save(key: URL.absoluteString, value: $0.data) }
			.subscribe()
			.disposed(by: disposeBag)
		
		return response
			.map { $0.data }
	}
}
