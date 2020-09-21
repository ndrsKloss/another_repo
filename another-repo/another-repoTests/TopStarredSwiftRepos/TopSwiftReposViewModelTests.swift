@testable import another_repo
import XCTest
import RxSwift
import RxCocoa
import RxTest

private let owner = TopStarSwiftModel.Owner(
	login: "awesome-ios",
	avatar_url: "https://avatars2.githubusercontent.com/u/484656?v=4"
)

private let repo = TopStarSwiftModel.Repository(
	name: "awesome-ios",
	owner: owner,
	description: "A curated list of awesome iOS ecosystem, including Objective-C and Swift Projects",
	stargazers_count: 35688
)

let model = TopStarSwiftModel(items: [repo])

final class TopSwiftReposViewModelTests:
XCTestCase {
	
	var scheduler: TestScheduler!
	var disposeBag: DisposeBag!
	var repository: TopStarSwiftRepositoryMock!
	var sut: TopSwiftReposViewModel!
	
	override func setUp() {
		super.setUp()
		scheduler = TestScheduler(initialClock: 0)
		disposeBag = DisposeBag()
		repository = TopStarSwiftRepositoryMock()
		sut = TopSwiftReposViewModel(repository: repository)
	}
	
	func test_cellsViewModels_from_viewWillAppear_trigger() {
		let cellsViewModels = scheduler.createObserver([TopStarSwiftRepositoryTableViewCellModel].self)
		
		let viewWillAppear = scheduler.createHotObservable(
			[.next(10, true)]
		)
		
		let input = TopSwiftReposViewModel.Input(
			viewWillAppear: .init(events: viewWillAppear),
			pullToRefresh: .init(events: Observable<Void>.empty()),
			retryTap: .init(events: Observable<Void>.empty()),
			nearBottom: .empty()
		)
		
		let output = sut.transform(input: input)
		
		output
			.repositories
			.drive(cellsViewModels)
			.disposed(by: disposeBag)
		
		scheduler.start()
		
		let viewModel = TopStarSwiftRepositoryTableViewCellModel(repo)
		
		XCTAssertEqual(cellsViewModels.events, [.next(10, [viewModel])])
	}
}

final class TopStarSwiftRepositoryMock:
TopStarSwiftFetchable {
	func fetchTopSwiftStarRepos(
		_ URL: URL?
	) -> Observable<TopStartSwiftResponse> {
		let model = TopStarSwiftModel(items: [repo])
		return .just((model, nil))
	}
}
