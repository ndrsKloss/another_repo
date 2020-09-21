import UIKit

final class TopSwiftReposCoordinator:
Coordinatable {
	
	let navigationController: UINavigationController
	
	init(
		navigationController: UINavigationController = UINavigationController()
	) {
		self.navigationController = navigationController
	}
	
	func start() {
		navigationController.pushViewController(
			TopSwiftReposViewController(),
			animated: true
		)
	}
}
