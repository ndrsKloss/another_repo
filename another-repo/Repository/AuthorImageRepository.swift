import Foundation
import RxSwift

final class AuthorImageRepository:
AuthorImageFetchable,
RepositoryOperationScheduable {
	
	var scheduler: OperationQueueScheduler {
		let operationQueue = OperationQueue()
		operationQueue.maxConcurrentOperationCount = 2
		operationQueue.qualityOfService = QualityOfService.userInitiated
		return OperationQueueScheduler(operationQueue: operationQueue)
	}
	
	func fetchImage(
		_ URL: URL?
	) -> Observable<Data> {
		guard let URL = URL else { return .empty() }
		
		return URLSession.shared.rx
			.response(request: URLRequest(url: URL))
			.observeOn(scheduler)
			.map { $0.data }
	}
}
