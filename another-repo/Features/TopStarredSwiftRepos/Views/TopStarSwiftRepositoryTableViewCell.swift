import UIKit
import RxSwift

final class TopStarSwiftRepositoryTableViewCell: UITableViewCell {
	
	typealias Constants = TopStarSwiftRepositoryTableViewCellModel.Constants
	typealias Input = TopStarSwiftRepositoryTableViewCellModel.Input
	
	private var disposeBag = DisposeBag()
	
	private let avatarImageView: UIImageView = {
		$0.contentMode = .scaleAspectFit
		$0.layer.cornerRadius = .smallx
		$0.layer.masksToBounds = true
		$0.translatesAutoresizingMaskIntoConstraints = false
		return $0
	}(UIImageView())
	
	private let ownerNameLabel: UILabel = {
		$0.font = UIFont.systemFont(ofSize: .mediumx, weight: .light)
		$0.numberOfLines = 0
		$0.translatesAutoresizingMaskIntoConstraints = false
		return $0
	}(UILabel())
	
	private let repositoryNameLabel: UILabel = {
		$0.font = UIFont.systemFont(ofSize: .mediumx, weight: .medium)
		$0.numberOfLines = 0
		$0.translatesAutoresizingMaskIntoConstraints = false
		return $0
	}(UILabel())
	
	private let repositoryDescriptionLabel: UILabel = {
		$0.numberOfLines = 0
		$0.translatesAutoresizingMaskIntoConstraints = false
		return $0
	}(UILabel())
	
	private let starImageView: UIImageView = {
		$0.image = UIImage(named: Constants.starImage)
		$0.tintColor = .darkGray
		$0.contentMode = .scaleAspectFit
		$0.translatesAutoresizingMaskIntoConstraints = false
		return $0
	}(UIImageView())
	
	private let stargazersCountLabel: UILabel = {
		$0.font = UIFont.systemFont(ofSize: .large, weight: .light)
		$0.textColor = .darkGray
		$0.numberOfLines = 0
		$0.translatesAutoresizingMaskIntoConstraints = false
		return $0
	}(UILabel())
	
	override init(
		style: UITableViewCell.CellStyle,
		reuseIdentifier: String?
	) {
		super.init(
			style: style,
			reuseIdentifier: reuseIdentifier
		)
		
		setupAvatarImageView()
		setupOwnerNameLabel()
		setupRepositoryNameLabel()
		setupRepositoryDescriptionLabel()
		setupStarImageView()
		setupStargazersCountLabel()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		return nil
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = DisposeBag()
	}
	
	private func setupAvatarImageView() {
		contentView.addSubview(avatarImageView)
		
		NSLayoutConstraint.activate([
			avatarImageView.heightAnchor.constraint(equalToConstant: .largex),
			avatarImageView.widthAnchor.constraint(equalToConstant: .largex),
			avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .large)
		])
	}
	
	private func setupOwnerNameLabel() {
		contentView.addSubview(ownerNameLabel)
		
		NSLayoutConstraint.activate([
			avatarImageView.centerYAnchor.constraint(equalTo: ownerNameLabel.centerYAnchor),
			ownerNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .large),
			ownerNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: .small),
			contentView.trailingAnchor.constraint(equalTo: ownerNameLabel.trailingAnchor, constant: .large)
		])
	}
	
	private func setupRepositoryNameLabel() {
		contentView.addSubview(repositoryNameLabel)
		
		NSLayoutConstraint.activate([
			repositoryNameLabel.topAnchor.constraint(equalTo: ownerNameLabel.bottomAnchor, constant: .mediumx),
			repositoryNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: repositoryNameLabel.trailingAnchor, constant: .large)
		])
	}
	
	private func setupRepositoryDescriptionLabel() {
		contentView.addSubview(repositoryDescriptionLabel)
		
		NSLayoutConstraint.activate([
			repositoryDescriptionLabel.topAnchor.constraint(equalTo: repositoryNameLabel.bottomAnchor, constant: .medium),
			repositoryDescriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: repositoryDescriptionLabel.trailingAnchor, constant: .large)
		])
	}
	
	private func setupStarImageView() {
		contentView.addSubview(starImageView)
		
		NSLayoutConstraint.activate([
			starImageView.heightAnchor.constraint(equalToConstant: .mediumx),
			starImageView.widthAnchor.constraint(equalToConstant: .mediumx),
			starImageView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
		])
	}
	
	private func setupStargazersCountLabel() {
		contentView.addSubview(stargazersCountLabel)
		
		NSLayoutConstraint.activate([
			starImageView.centerYAnchor.constraint(equalTo: stargazersCountLabel.centerYAnchor),
			stargazersCountLabel.topAnchor.constraint(equalTo: repositoryDescriptionLabel.bottomAnchor, constant: .large),
			stargazersCountLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: .small),
			contentView.bottomAnchor.constraint(equalTo: stargazersCountLabel.bottomAnchor, constant: .large)
		])
	}
	
	func configureWith(_ viewModel: TopStarSwiftRepositoryTableViewCellModel) {
		let output = viewModel.transform(input: Input())

		output.imageData
			.map { UIImage(data: $0) }
			.drive(avatarImageView.rx.image)
			.disposed(by: disposeBag)
		
		output.ownerName
			.drive(ownerNameLabel.rx.text)
			.disposed(by: disposeBag)
			
		output.repositoryName
			.drive(repositoryNameLabel.rx.text)
			.disposed(by: disposeBag)
		
		output.repositoryDescription
			.drive(repositoryDescriptionLabel.rx.text)
			.disposed(by: disposeBag)
		
		output.repositoryStargazersCount
			.drive(stargazersCountLabel.rx.text)
			.disposed(by: disposeBag)
	}
}
