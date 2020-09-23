import UIKit
import RxSwift
import RxCocoa

final class TopSwiftReposViewController:
UIViewController,
UIScrollViewDelegate {
	
	typealias Input = TopSwiftReposViewModel.Input
	
	private let viewModel: TopSwiftReposViewModel
	
	private let disposeBag = DisposeBag()
	
	private let errorView: TopStarSwiftRepositoryErrorView = {
		$0.translatesAutoresizingMaskIntoConstraints = false
		return $0
	}(TopStarSwiftRepositoryErrorView())
	
	private let refreshControl = UIRefreshControl()
	
	private let activityView: UIActivityIndicatorView = {
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.hidesWhenStopped = true
		return $0
	}(UIActivityIndicatorView(style: .medium))
	
	private let navigationBarActivityView: UIActivityIndicatorView = {
		$0.hidesWhenStopped = true
		return $0
	}(UIActivityIndicatorView(style: .medium))
	
	private let tableView: UITableView = {
		$0.showsVerticalScrollIndicator = false
		$0.backgroundColor = .systemGray5
		$0.tableFooterView = UIView()
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.estimatedRowHeight = UITableView.automaticDimension
		return $0
	}(UITableView())
	
	init(
		viewModel: TopSwiftReposViewModel = TopSwiftReposViewModel()
	) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(
		coder aDecoder: NSCoder
	) {
		return nil
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupActivityIndicator()
		setupTableView()
		setupErrorView()
		bind()
	}
	
	private func setupView() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationBarActivityView)
		view.backgroundColor = .systemGray5
	}
	
	private func setupTableView() {
		view.addSubview(tableView)
		
		tableView.addSubview(refreshControl)
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
			view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
		])
	}
	
	private func setupActivityIndicator() {
		view.addSubview(activityView)
		
		NSLayoutConstraint.activate([
			activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
	
	private func setupErrorView() {
		view.addSubview(errorView)
		
		NSLayoutConstraint.activate([
			errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
	
	private func bind() {
		let intput = Input(
			viewWillAppear: rx.viewWillAppear,
			pullToRefresh: refreshControl.rx.controlEvent(.valueChanged),
			retryTap: errorView.button.rx.tap,
			nearBottom: tableView.rx.nearBottom
		)
		
		let output = viewModel.transform(input: intput)

		let configureCell = { (tableView: UITableView, row: Int, viewModel: TopStarSwiftRepositoryTableViewCellModel) -> UITableViewCell in
			let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as? TopStarSwiftRepositoryTableViewCell ??
				TopStarSwiftRepositoryTableViewCell(style: .default, reuseIdentifier: "RepositoryCell")
			
			cell.configureWith(viewModel)
			
			return cell
		}
		
        /*
         Warning once only: UITableView was told to layout its visible cells and other contents without being in the view hierarchy (the table view or one of its superviews has not been added to a window).
         
         Issue:
         https://github.com/RxSwiftCommunity/RxDataSources/issues/331
         
         Correção:
         https://github.com/ReactiveX/RxSwift/pull/2076 - RxSwift 6.0.0-beta.1
         */
		
		output
			.repositories
			.drive(tableView.rx.items)(configureCell)
			.disposed(by: disposeBag)
		
		output
			.success
			.drive(onNext: { [weak self] _ in self?.success() })
			.disposed(by: disposeBag)
		
		output
			.normalLoad
			.drive(onNext: { [weak self] _ in self?.load() })
			.disposed(by: disposeBag)
		
		output
			.succLoad
			.drive(navigationBarActivityView.rx.isAnimating)
			.disposed(by: disposeBag)
		
		output
			.pullToRefreshLoad
			.drive(refreshControl.rx.isRefreshing)
			.disposed(by: disposeBag)
		
		output
			.errorContent
			.drive(onNext: { [weak self] in
				self?.errorView.configure(with: $0)
				self?.error()
			})
			.disposed(by: disposeBag)
	}
	
	private func success() {
		activityView.stopAnimating()
		errorView.isHidden = true
		tableView.isHidden = false
	}
	
	private func error() {
		tableView.isHidden = true
		activityView.stopAnimating()
		errorView.isHidden = false
	}
	
	private func load() {
		tableView.isHidden = true
		errorView.isHidden = true
		activityView.startAnimating()
	}
}
