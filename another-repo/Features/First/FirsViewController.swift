import UIKit

typealias Constants = FirstViewModel.Constants
typealias Input = FirstViewModel.Input

final class FirstViewController: UIViewController {
	
	private let viewModel: FirstViewModel
	
	private let button: UIButton = {
		$0.setTitle(Constants.buttonTitle, for: .normal)
		$0.apply(style: .normal)
		return $0
	}(UIButton())
	
	init(
		viewModel: FirstViewModel = FirstViewModel()
	) {
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
		setupView()
		setupButton()
		bind()
	}
	
	private func bind() {
		let input = Input(
			startButtonTap: button.rx.tap
		)
		
		_ = viewModel.transform(input: input)
	}
	
	private func setupView() {
		view.backgroundColor = .systemGray5
	}
	
	private func setupButton() {
		view.addSubview(button)

		NSLayoutConstraint.activate([
			button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: .large),
			button.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: .large),
			view.trailingAnchor.constraint(greaterThanOrEqualTo: button.trailingAnchor, constant: .large),
			view.bottomAnchor.constraint(greaterThanOrEqualTo: button.bottomAnchor, constant: .large)
		])
	}
}
