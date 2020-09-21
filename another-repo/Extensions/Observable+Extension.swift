// @sergdort
import RxSwift
import RxCocoa

extension ObservableType {
	func asDriverOnErrorJustComplete() -> Driver<Element> {
		return asDriver { error in
			return Driver.empty()
		}
	}
}
