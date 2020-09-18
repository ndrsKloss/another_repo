import UIKit

final class TopSwiftReposCoordinator:
Coordinator {
	
	private let navigationController: UINavigationController?
	
	init(
		navigationController: UINavigationController?
	) {
		self.navigationController = navigationController
	}
	
	func start() {
		let viewModel = TopSwiftReposViewModel()
		let viewController = TopSwiftReposViewController(
			viewModel: viewModel
		)
		
		navigationController?.pushViewController(
			viewController,
			animated: true
		)
	}
}
