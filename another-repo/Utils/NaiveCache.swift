import Foundation

// Naive approach
final class NaiveCache: NaiveCachable {
	func save(key: String, value: Data) {
		if let encoded = try? JSONEncoder().encode(value) {
			UserDefaults.standard.set(encoded, forKey: key)
		}
	}
	
	func load(key: String) -> Data? {
		if let data = UserDefaults.standard.data(forKey: key) {
			if let decoded = try? JSONDecoder().decode(Data.self, from: data) {
				return decoded
			} else { return nil }
		} else { return nil }
	}
}
