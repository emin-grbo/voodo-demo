import Foundation

struct TiseResponse: Codable {
  var listings: [Listing]
  var categories: [Category]?
}

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

struct Owner: Codable {
    let id: String
    let username: String
    let name: String
    let picture: String
}

struct Category: Identifiable, Codable, Hashable {
    let id: String           // Unique identifier (e.g., "wearables.clothes.jackets")
    let title: String        // Display title (e.g., "Jackets")
    let icon: String         // Icon URL or local file path
}

enum Size: String, CaseIterable {
  case XS = "XS"
  case S = "S"
  case M = "M"
  case L = "L"
  case XL = "XL"
  case notApplicable = "Not Applicable"
}
