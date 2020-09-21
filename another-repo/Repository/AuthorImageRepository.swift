import Foundation
import RxSwift

struct AuthorImageRepository: AuthorImageFetchable {
	func fetchImage(
		_ URL: URL?
	) -> Observable<Data> {
		
		let operationQueue = OperationQueue()
		operationQueue.maxConcurrentOperationCount = 2
		operationQueue.qualityOfService = QualityOfService.userInitiated
		
		guard let URL = URL else {
				return .empty()
		}
		
		return URLSession.shared.rx
			.response(request: URLRequest(url: URL))
			.observeOn(OperationQueueScheduler(operationQueue: operationQueue))
			.map { $0.data }
	}
}
