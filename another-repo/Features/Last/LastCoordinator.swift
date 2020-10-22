import UIKit
import RxSwift
import RxCocoa

final class LastCoordinator: Coordinatable {
	
	let navigationController: UINavigationController
	
	private let disposeBag = DisposeBag()
	private let text: String
	
	init(
		navigationController: UINavigationController = UINavigationController(),
		text: String
	) {
		self.navigationController = navigationController
		self.text = text
	}
	
	func start() {
		let viewModel = LastViewModel(text)
		let viewController = LastViewController(viewModel: viewModel)
		
		navigationController.pushViewController(
			viewController,
			animated: true
		)
	}
}
