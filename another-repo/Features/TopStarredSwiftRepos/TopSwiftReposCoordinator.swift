import UIKit
import RxSwift

final class TopSwiftReposCoordinator: Coordinatable {
	
	let navigationController: UINavigationController
	
	private let disposeBag = DisposeBag()
	
	init(
		navigationController: UINavigationController = UINavigationController()
	) {
		self.navigationController = navigationController
	}
	
	func start() {
		let repository = TopStarSwiftRepository(
			parser: NextURLParser(),
			repositoryOperation: RepositoryOperation()
		)
		
		let viewModel = TopSwiftReposViewModel(repository: repository)
		let viewController = TopSwiftReposViewController(viewModel: viewModel)
		
		navigationController.pushViewController(
			viewController,
			animated: true
		)
		
		viewModel.navigation
			.filter { $0.destination == .last }
			.map { $0.getLuggage() }
			.unwrap()
			.drive(onNext: { [startLast] (luggage: String) in
				startLast(luggage)
			})
			.disposed(by: disposeBag)
	}
	
	func startLast(_ text: String) {
		let coordinator = LastCoordinator(
			navigationController: navigationController,
			text: text
		)
		coordinator.start()
	}
}
