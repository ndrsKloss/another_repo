// @kzaher
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
	var nearBottom: Signal<Void> {
		func isNearBottomEdge(
			tableView: UITableView,
			edgeOffset: CGFloat = 20.0
		) -> Bool {
			return tableView.contentOffset.y +
				tableView.frame.size.height +
				edgeOffset >
				tableView.contentSize.height
		}
		
		return self.contentOffset
			.asDriver()
			.flatMap { _ in
				if isNearBottomEdge(tableView: self.base, edgeOffset: 20.0) { return .just(()) }
				return .empty()
			}
	}
}
