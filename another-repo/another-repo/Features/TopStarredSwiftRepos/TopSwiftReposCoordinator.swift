import UIKit

final class TopSwiftReposCoordinator:
Coordinatable {
	
	let navigationController: UINavigationController = UINavigationController()
	
	func start() {
		navigationController.pushViewController(
			TopSwiftReposViewController(),
			animated: true
		)
	}
}
