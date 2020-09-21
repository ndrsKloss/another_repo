struct TopStarSwiftModel: Decodable {
	
	struct Owner: Decodable {
		let login: String
		let avatar_url: String
	}
	
	struct Repository: Decodable {
		let name: String
		let owner: Owner
		let description: String?
		let stargazers_count: Int
	}
	
	let items: [Repository]
}
