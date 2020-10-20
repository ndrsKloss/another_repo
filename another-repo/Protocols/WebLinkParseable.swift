import Foundation

protocol WebLinkParseable {
	func parse(
		_ httpResponse: HTTPURLResponse?
	) throws -> URL?
}
