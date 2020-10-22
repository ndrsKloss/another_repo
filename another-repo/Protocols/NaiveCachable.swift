import Foundation

protocol NaiveCachable {
	func save(key: String, value: Data)
	func load(key: String) -> Data?
}
