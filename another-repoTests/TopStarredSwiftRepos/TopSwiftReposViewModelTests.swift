/*
There are a lot of more scenarios to be tested. That is a little of I'm capable of.
*/

@testable import another_repo
import XCTest
import RxSwift
import RxCocoa
import RxTest

final class TopSwiftReposViewModelTests:
XCTestCase {
	
	func test_when_viewWillAppear_is_triggered() {
		let (sut, fields) = makeSut()
		
		let cellsViewModels = fields.scheduler.createObserver([TopStarSwiftRepositoryTableViewCellModel].self)
		
		let viewWillAppear = fields.scheduler.createHotObservable(
			[.next(0, true)]
		)
		
		let input = TopSwiftReposViewModel.Input(
			viewWillAppear: .init(events: viewWillAppear),
			itemSelected: .init(events: Observable<IndexPath>.empty()),
			retryTap: .init(events: Observable<Void>.empty()),
			nearBottom: .empty()
		)
		
		let output = sut.transform(input: input)
		
		output
			.repositories
			.drive(cellsViewModels)
			.disposed(by: fields.disposeBag)
		
		fields.scheduler.start()
		
		XCTAssertEqual(cellsViewModels.events, [.next(0, [fields.cellViewModel]), .completed(0)])
	}
	
	func test_when_nearBottom_is_triggered() {
		let (sut, fields) = makeSut()
		
		let cellsViewModels = fields.scheduler.createObserver([TopStarSwiftRepositoryTableViewCellModel].self)
		
		let viewWillAppear = fields.scheduler.createHotObservable(
			[.next(0, true)]
		)
		
		let nearBottom = fields.scheduler.createHotObservable(
			[.next(10, Void())]
		)
			.asSignal(onErrorJustReturn: ())
		
		let input = TopSwiftReposViewModel.Input(
			viewWillAppear: .init(events: viewWillAppear),
			itemSelected: .init(events: Observable<IndexPath>.empty()),
			retryTap: .init(events: Observable<Void>.empty()),
			nearBottom: nearBottom
		)
		
		let output = sut.transform(input: input)
		
		output
			.repositories
			.drive(cellsViewModels)
			.disposed(by: fields.disposeBag)
		
		fields.scheduler.start()
		
		XCTAssertEqual(cellsViewModels.events, [
			.next(0, [fields.cellViewModel]),
			.next(10, [fields.cellViewModel, fields.cellViewModel])
		])
	}
}

extension TopSwiftReposViewModelTests {
	typealias Sut = TopSwiftReposViewModel
	typealias Fields = (
		scheduler: TestScheduler,
		disposeBag: DisposeBag,
		cellViewModel: TopStarSwiftRepositoryTableViewCellModel
	)
	
	
	final class TopStarSwiftRepositoryMock: TopStarSwiftFetchable {
		func fetchTopSwiftStarRepos(
			_ URL: URL?
		) -> Observable<TopStartSwiftResponse> {
			.just((makeTopStarSwiftModel(), nil))
		}
	}
	
	final class AuthorImageFetchMock: AuthorImageFetchable {
		func fetchImage(_ URL: URL?) -> Observable<Data> {
			.empty()
		}
	}
	
	func makeSut() -> (
		sut: Sut,
		fields: Fields
		) {
			let mock = TopStarSwiftRepositoryMock()
			let sut = TopSwiftReposViewModel(repository: mock)
			let scheduler = TestScheduler(initialClock: 0)
			let disposeBag = DisposeBag()
			
			let cellViewModel = TopStarSwiftRepositoryTableViewCellModel(repository: AuthorImageFetchMock(), makeRepository())
			
			return (sut, (scheduler, disposeBag, cellViewModel))
	}
}

private func makeRepository() -> TopStarSwiftModel.Repository {
	let owner = TopStarSwiftModel.Owner(
		login: "awesome-ios",
		avatar_url: "https://avatars2.githubusercontent.com/u/484656?v=4"
	)
	
	let repo = TopStarSwiftModel.Repository(
		id: 21700699,
		name: "awesome-ios",
		owner: owner,
		description: "A curated list of awesome iOS ecosystem, including Objective-C and Swift Projects",
		stargazers_count: 35688
	)
	
	return repo
}

private func makeTopStarSwiftModel() -> TopStarSwiftModel {
	TopStarSwiftModel(items: [makeRepository()])
}
