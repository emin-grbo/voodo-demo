struct Listing: Identifiable, Codable, Hashable {
  static let databaseTableName = "listing" /// used specifically for GRDB
  let id: String
  let createdAt: String
  let title: String
  let caption: String
  let size: String
  let category: String
  let askingPrice: Int
  let currency: String
  let likeCount: Int
  var liked: Bool
  let sold: Bool
  let owner: Owner
  let primaryImage: String
  
  static func == (lhs: Listing, rhs: Listing) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
