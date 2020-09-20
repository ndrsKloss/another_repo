import Foundation
import RxSwift

protocol TopStarSwiftFetchable {
	func fetchTopSwiftStarRepos(
		_ URL: URL?
	) -> Observable<TopStartSwiftResponse>
}

protocol AuthorImageFetchable {
	func fetchImage(
		_ URL: URL?
	) -> Observable<Data>
}
