import Foundation
import SwiftUI

class MainObservable: ObservableObject {
  
  // MARK: Services
  private var tiseAPI: TiseAPI?
  
  // MARK: Published Properties
  @Published var listings: [Listing] = []
  @Published var categories: [Category] = []
  @Published var isError: Bool = false
  @Published var errorMessage: String = "Error Occured"
  
  // MARK: Layout
  var baseItemSize: CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    let spacing: CGFloat = Constants.columnSpacing
    let totalSpacing = spacing * CGFloat(Constants.columnCount + 1)
    return (screenWidth - totalSpacing) / CGFloat(Constants.columnCount)
  }
  
  init(api: TiseAPI = TiseAPI()) {
    self.tiseAPI = api
    fetchData()
  }
  
  func fetchData() {
    let fetchedData = tiseAPI?.loadLocalData()
    listings = fetchedData?.listings ?? []
    categories = fetchedData?.categories ?? []
    categories.append(Constants.categoryPlaceholder)
  }
  
  func addListing(
    title: String,
    description: String,
    size: Size,
    category: Category,
    price: String
  ) -> Bool {
    
    let newListing = Listing(
      id: UUID().uuidString,
      createdAt: Date().ISO8601Format(),
      title: title,
      caption: description,
      size: size.rawValue,
      category: category.id,
      askingPrice: Int(price) ?? 0,
      currency: Constants.defaultCurrency,
      likeCount: 0,
      liked: false,
      sold: false,
      owner: Owner(
        id: "",
        username: "local",
        name: "local",
        picture: "none"
      ),
      primaryImage: "",
      secondaryImage: "local"
    )
    
    do {
      try tiseAPI?.addListing(newListing: newListing)
      print("✅ Added new Listing")
      fetchData()
      return true
    } catch {
      errorMessage = error.localizedDescription
      isError.toggle()
      print("⛔️ Failed to add new Listing")
      return false
    }
  }
}
