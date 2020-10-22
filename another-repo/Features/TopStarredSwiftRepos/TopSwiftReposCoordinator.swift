import UIKit

final class TopSwiftReposCoordinator: Coordinatable {
	
	let navigationController: UINavigationController
	
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
	}
}
