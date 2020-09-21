import UIKit

struct TopStarSwiftRepositoryErrorContent {
	let errorMessage: String
	let buttonTitle: String
	
	init(
		errorMessage: String = "Something went wrong.",
		buttonTitle: String = "Try Again"
	) {
		self.errorMessage = errorMessage
		self.buttonTitle = buttonTitle
	}
}

final class TopStarSwiftRepositoryErrorView:
UIView {
	
	let messageLabel: UILabel = {
		$0.font = UIFont.systemFont(ofSize: .mediumx, weight: .light)
		$0.numberOfLines = 0
		$0.translatesAutoresizingMaskIntoConstraints = false
		return $0
	}(UILabel())
	
	let button: UIButton = {
		$0.contentEdgeInsets = UIEdgeInsets(top: .small, left: .small, bottom: .small, right: .small)
		$0.layer.cornerRadius = .smallx
		$0.layer.masksToBounds = true
		$0.titleLabel?.font = UIFont.systemFont(ofSize: .mediumx, weight: .medium)
		$0.tintColor = .black
		$0.backgroundColor = .white
		$0.translatesAutoresizingMaskIntoConstraints = false
		return $0
	}(UIButton(type: .system))
	
	init() {
		super.init(frame: .zero)
		setupView()
		setupMessageLabel()
		setupButton()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		return nil
	}
	
	func configure(with content: TopStarSwiftRepositoryErrorContent) {
		messageLabel.text = content.errorMessage
		button.setTitle(content.buttonTitle, for: .normal)
	}
	
	private func setupView() {
		backgroundColor = .clear
	}
	
	private func setupMessageLabel() {
		addSubview(messageLabel)
		
		NSLayoutConstraint.activate([
			messageLabel.topAnchor.constraint(equalTo: topAnchor),
			messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor)
		])
	}
	
	private func setupButton() {
		addSubview(button)
		
		NSLayoutConstraint.activate([
			button.centerXAnchor.constraint(equalTo: messageLabel.centerXAnchor),
			button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: .mediumx),
			button.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
			trailingAnchor.constraint(greaterThanOrEqualTo: button.trailingAnchor),
			bottomAnchor.constraint(equalTo: button.bottomAnchor)
		])
	}
}
