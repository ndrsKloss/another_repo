import RxSwift

protocol RepositoryOperationScheduable {
	var scheduler: OperationQueueScheduler { get }
}

