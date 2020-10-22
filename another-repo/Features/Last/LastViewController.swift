import UIKit
import RxSwift
import RxCocoa

final class LastViewController: UIViewController {

	typealias Input = LastViewModel.Input
	
	private let disposeBag = DisposeBag()
	private let viewModel: LastViewModel
	
	private let label: UILabel = {
		$0.font = UIFont.systemFont(ofSize: .largex, weight: .medium)
		$0.textAlignment = .center
		$0.numberOfLines = 0
		$0.translatesAutoresizingMaskIntoConstraints = false
		return $0
	}(UILabel())
	
	init(
		viewModel: LastViewModel
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
		setupLabel()
		bind()
	}
	
	private func bind() {
		let output = viewModel.transform(input: Input())
		
		output.text
			.drive(label.rx.text)
			.disposed(by: disposeBag)
	}
	
	private func setupView() {
		view.backgroundColor = .systemGray5
	}
	
	private func setupLabel() {
		view.addSubview(label)

		NSLayoutConstraint.activate([
			label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			label.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: .large),
			label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: .large),
			view.trailingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: .large),
			view.bottomAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: .large)
		])
	}
}
