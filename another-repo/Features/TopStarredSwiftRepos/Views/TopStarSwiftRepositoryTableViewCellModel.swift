import RxSwift
import RxCocoa

final class TopStarSwiftRepositoryTableViewCellModel:
ViewModelType {
	
	struct Input { }
	
	struct Output {
		let repositoryName: Driver<String>
		let repositoryDescription: Driver<String?>
		let repositoryStargazersCount: Driver<String>
		let ownerName: Driver<String>
		let avatarURL: Driver<String>
		let imageData: Driver<Data>
	}
	
	private let repository: AuthorImageFetchable
	let repositoryName: String
	let repositoryDescription: String?
	let repositoryStargazersCount: Int
	let ownerName: String
	let avatarURL: String
	
	init(
		repository: AuthorImageFetchable = AuthorImageRepository(),
		_ gitHubrepository: TopStarSwiftModel.Repository
	) {
		self.repository = repository
		repositoryName = gitHubrepository.name
		repositoryDescription = gitHubrepository.description
		repositoryStargazersCount = gitHubrepository.stargazers_count
		ownerName = gitHubrepository.owner.login
		avatarURL = gitHubrepository.owner.avatar_url
	}
	
	func transform(input: Input) -> Output {
		let repositoryStargazersCount = Driver.just(self.repositoryStargazersCount)
			.map { String($0) }
		
		let imageData = fetchImage(URL: URL(string: avatarURL))
			.asDriver(onErrorDriveWith: .empty())
		
		return Output(
			repositoryName: Driver.just(repositoryName),
			repositoryDescription: Driver.just(repositoryDescription),
			repositoryStargazersCount: repositoryStargazersCount,
			ownerName: Driver.just(ownerName),
			avatarURL: Driver.just(avatarURL),
			imageData: imageData
		)
	}
	
	private func fetchImage(
		URL: URL?
	) -> Observable<Data> {
		repository.fetchImage(URL)
			.catchError { _ in .empty() }
	}
}

extension TopStarSwiftRepositoryTableViewCellModel: Equatable { }

func == (
	lhs: TopStarSwiftRepositoryTableViewCellModel,
	rhs: TopStarSwiftRepositoryTableViewCellModel
) -> Bool {
	lhs.repositoryName == rhs.repositoryName &&
		lhs.repositoryDescription == rhs.repositoryDescription &&
		lhs.repositoryStargazersCount == rhs.repositoryStargazersCount &&
		lhs.ownerName == rhs.ownerName &&
		lhs.avatarURL == rhs.avatarURL
}


