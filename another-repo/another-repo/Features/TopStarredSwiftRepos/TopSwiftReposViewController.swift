import UIKit

final class TopSwiftReposViewController:
UIViewController {
	
	private let viewModel: TopSwiftReposViewModel
	
	init(viewModel: TopSwiftReposViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(
		coder aDecoder: NSCoder
	) {
		return nil
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .green
	}
}
