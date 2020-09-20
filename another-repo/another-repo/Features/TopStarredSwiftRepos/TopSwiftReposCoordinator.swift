import UIKit

final class TopSwiftReposCoordinator:
Coordinatable {
	
	private let navigationController: UINavigationController?
	
	init(
		navigationController: UINavigationController?
	) {
		self.navigationController = navigationController
	}
	
	func start() {
		navigationController?.pushViewController(
			TopSwiftReposViewController(),
			animated: true
		)
	}
}
