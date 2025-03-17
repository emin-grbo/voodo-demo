import Foundation

struct Constants {
  // number of columns on the listing page
  static let columnCount: Int = 2
  // spacing between items on the listing page
  static let columnSpacing: CGFloat = 16
  // basic corner radius
  static let cornerRadius: CGFloat = 16
  // default currency
  static let defaultCurrency: String = "NOK"
  // base non-selected category
  static let categoryPlaceholder = Category(id: "0", title: "Select a category", icon: "no icon"
  )
  // base local owner (due to not having the ability to make a custom one)
  static let hardcodedOwner = Owner(
    id: 0,
    username: "localEmin",
    name: "local",
    picture: "https://tise-static.telenorcdn.net/profile-pictures/5addf35ab461be00157d2e83/26ae2353-bdcf-47f2-b579-67f0e9b4b31f"
  )
  // max count for entry
  static let maxCharCount = 20
}
