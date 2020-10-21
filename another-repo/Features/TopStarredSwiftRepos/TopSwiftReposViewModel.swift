import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

final class TopSwiftReposViewModel: ViewModelType {
	
	struct Input {
		let viewWillAppear: ControlEvent<Bool>
		let retryTap: ControlEvent<Void>
		let nearBottom: Signal<Void>
	}
	
	struct Output {
		let repositories: Driver<[TopStarSwiftRepositoryTableViewCellModel]>
		let success: Driver<Void>
		let normalLoad: Driver<Bool>
		let succLoad: Driver<Bool>
		let errorContent: Driver<TopStarSwiftRepositoryErrorContent>
	}
	
	private let repository: TopStarSwiftFetchable
	private var nextURL: URL?
	private var repositories = [TopStarSwiftModel.Repository]()
	
	init(repository: TopStarSwiftFetchable = TopStarSwiftRepository()) {
		self.repository = repository
	}
	
	func transform(input: Input) -> Output {
		
		let firstReposPageTracker = ActivityIndicator()
		
		let errorTracker = ErrorTracker()
		
		let firstReposPage = Observable.merge(
			input.viewWillAppear.map { _ in () },
			input.retryTap.asObservable()
			)
			.flatMapLatest { [fetchRepos] _ in
				fetchRepos(EndpointsRepository.topStarsSwift, firstReposPageTracker, errorTracker)
			}
			.map { [unwrapResponse] in try unwrapResponse($0) }
			.unwrap()
		
		let succReposPageTracker = ActivityIndicator()
		
		let succReposPage = input.nearBottom
			.asObservable()
			.map { [getNextURL] _ in getNextURL() }
			.distinctUntilChanged()
			.flatMapLatest { [fetchRepos] in fetchRepos($0, succReposPageTracker, errorTracker) }
			.map { [unwrapResponse] in try unwrapResponse($0) }
			.unwrap()
		
		let repositories = Observable.merge(firstReposPage, succReposPage)
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
			errorContent: errorContent
		)
	}
	
	private func fetchRepos(
		URL: URL?,
		_ tracker: ActivityIndicator,
		_ errorTracker: ErrorTracker
	) -> Observable<TopStartSwiftResponse> {
		repository.fetchTopSwiftStarRepos(URL)
			.trackError(errorTracker)
			.trackActivity(tracker)
			.catchError { _ in .empty() }
	}
	
	private func unwrapResponse(
		_ response: TopStartSwiftResponse
	)  throws -> [TopStarSwiftModel.Repository] {
		storeNextURL(response.nextURL)
		updateRepositories(response.repositories.items)
		return getRepositories()
	}
	
	private func storeNextURL(_ URL: URL?) {
		nextURL = URL
	}
	
	private func getNextURL() -> URL? {
		return nextURL
	}
	
	private func updateRepositories(
		_ repositories: [TopStarSwiftModel.Repository]
	) {
		self.repositories += repositories
	}
	
	private func getRepositories()
		-> [TopStarSwiftModel.Repository] {
		self.repositories
	}
}
