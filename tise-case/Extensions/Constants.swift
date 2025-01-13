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
}
