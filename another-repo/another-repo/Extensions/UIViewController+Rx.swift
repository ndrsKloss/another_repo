// @devxoul
import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
	var viewWillAppear: ControlEvent<Bool> {
		let source = self.methodInvoked(#selector(Base.viewWillAppear))
			.map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}
}
