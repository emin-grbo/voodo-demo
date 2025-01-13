struct Listing: Identifiable, Codable {
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
    let secondaryImage: String?
}
