import RxSwift

struct RepositoryOperation: RepositoryOperationScheduable {
	
	private let operationQueue: OperationQueue = {
		$0.maxConcurrentOperationCount = 2
		$0.qualityOfService = QualityOfService.userInitiated
		return $0
	}(OperationQueue())

	var scheduler: OperationQueueScheduler
	
	init() {
		scheduler = OperationQueueScheduler(operationQueue: operationQueue)
	}
}
