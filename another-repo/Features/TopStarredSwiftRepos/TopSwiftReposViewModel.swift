import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

final class TopSwiftReposViewModel:
ViewModelType {
	
	struct Input {
		let viewWillAppear: ControlEvent<Bool>
		let pullToRefresh: ControlEvent<Void>
		let retryTap: ControlEvent<Void>
		let nearBottom: Signal<Void>
	}
	
	struct Output {
		let repositories: Driver<[TopStarSwiftRepositoryTableViewCellModel]>
		let success: Driver<Void>
		let normalLoad: Driver<Bool>
		let succLoad: Driver<Bool>
		let pullToRefreshLoad: Driver<Bool>
		let errorContent: Driver<TopStarSwiftRepositoryErrorContent>
	}
	
	private let repository: TopStarSwiftFetchable
	private var nextURL: URL?
	private var repositories = [TopStarSwiftModel.Repository]()
	
	init(
		repository: TopStarSwiftFetchable = TopStarSwiftRepository()
	) {
		self.repository = repository
	}
	
	func transform(
		input: Input
	) -> Output {
		
		let firstReposPageTracker = ActivityIndicator()
		
		let errorTracker = ErrorTracker()
		
		let firstReposPage = Observable.merge(
			input.viewWillAppear.map { _ in Void() },
			input.retryTap.asObservable()
		)
			.flatMapLatest { [weak self] _ -> Observable<TopStartSwiftResponse> in
				guard let self = self else { return .empty() }
				return self.fetchRepos(firstReposPageTracker, errorTracker)
		}
		.map { [weak self] in try self?.unwrapResponse($0) }
		.unwrap()
		
		let pullToRefreshReposPageTracker = ActivityIndicator()
		
		let pullToRefreshPage = input.pullToRefresh
			.asObservable()
			.flatMapLatest { [weak self] _ -> Observable<TopStartSwiftResponse> in
				guard let self = self else { return .empty() }
				return self.fetchRepos(pullToRefreshReposPageTracker, errorTracker)
		}
		.map { [weak self] in try self?.unwrapResponse($0) }
		.unwrap()
		.map { [weak self] repositories -> [TopStarSwiftModel.Repository] in
			guard let self = self else { return [] }
			return self.resetRepositories(repositories)
		}
		
		let succReposPageTracker = ActivityIndicator()
		
		let succReposPage = input.nearBottom
			.skip(2)
			.asObservable()
			.map { [weak self] _ -> URL? in
				guard let self = self else { return nil }
				return self.catchNextURL()
		}
		.distinctUntilChanged()
		.flatMapLatest { [weak self] URL -> Observable<TopStartSwiftResponse> in
			guard let self = self else { return .empty() }
			return self.fetchRepos(URL: URL, succReposPageTracker, errorTracker)
		}
		.map { [weak self] in try self?.unwrapResponse($0) }
		.unwrap()
		.map { [weak self] repositories -> [TopStarSwiftModel.Repository] in
					guard let self = self else { return [] }
					return self.updateRepositories(repositories)
		}
		
		let repositories = Observable.merge(firstReposPage, succReposPage, pullToRefreshPage)
		.map { $0.map { TopStarSwiftRepositoryTableViewCellModel($0) } }
		.asDriver(onErrorJustReturn: [])
		
		let normalLoad = firstReposPageTracker
			.filter { $0 }
			.asDriver(onErrorJustReturn: false)
		
		let success = repositories
			.map { _ in Void() }
			.asDriver(onErrorDriveWith: .empty())
		
		let errorContent = errorTracker
			.map { _ in TopStarSwiftRepositoryErrorContent.init() }
			.asDriver(onErrorDriveWith: .empty())
		
		return Output(
			repositories: repositories,
			success: success,
			normalLoad: normalLoad,
			succLoad: succReposPageTracker.asDriver(onErrorJustReturn: false),
			pullToRefreshLoad: pullToRefreshReposPageTracker.asDriver(onErrorJustReturn: false),
			errorContent: errorContent
		)
	}
	
	private func fetchRepos(
		URL: URL? = URL(string: "https://api.github.com/search/repositories?q=language:swift&sort=stars"),
		_ tracker: ActivityIndicator,
		_ errorTracker: ErrorTracker
	) -> Observable<TopStartSwiftResponse> {
		repository.fetchTopSwiftStarRepos(URL)
			.trackError(errorTracker)
			.trackActivity(tracker)
			.catchError { _ in return .empty() }
	}
	
	private func unwrapResponse(
		_ response: TopStartSwiftResponse
	)  throws -> [TopStarSwiftModel.Repository] {
		self.nextURL = response.nextURL
		return response.repositories.items
	}
	
	private func catchNextURL() -> URL? {
		return nextURL
	}
	
	private func resetRepositories(
		_ repositories: [TopStarSwiftModel.Repository]
	) -> [TopStarSwiftModel.Repository] {
		self.repositories = repositories
		return self.repositories
	}
	
	private func updateRepositories(
		_ repositories: [TopStarSwiftModel.Repository]
	) -> [TopStarSwiftModel.Repository] {
		self.repositories += repositories
		return self.repositories
	}
}
