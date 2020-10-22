import RxSwift
import RxCocoa

/*
The only purpose of this view model is to show some interaction with the coordinator.
*/

final class LastViewModel: ViewModelType {
	
	struct Input { }
	
	struct Output {
		let text: Driver<String>
	}
	
	private let text: String
	
	init(_ text: String) {
		self.text = text
	}
	
	func transform(input: Input) -> Output {
		Output(text: .just(text))
	}
}
