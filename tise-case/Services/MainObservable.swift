import Foundation
import SwiftUI

class MainObservable: ObservableObject {
  
  // MARK: Services
  private var tiseAPI: TiseAPI?
  
  // MARK: State Control
  @Published var selectedTab: Tabs = .list
  @Published var isShowingDetail = false
  @Published var isShowingError = false
  @Published var selectedItem: Listing?
  
  // MARK: Published Properties
  @Published var listings: [Listing] = []
  @Published var isError: Bool = false
  @Published var errorMessage: String = "Error Occured"
  
  // MARK: Layout
  var baseItemSize: CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    let spacing: CGFloat = Constants.columnSpacing
    let totalSpacing = spacing * CGFloat(Constants.columnCount + 1)
    return (screenWidth - totalSpacing) / CGFloat(Constants.columnCount)
  }
  
  var categories: [Category] = []
  
  init(api: TiseAPI = TiseAPI()) {
    self.tiseAPI = api
    refreshData()
  }
  
  func refreshData() {
    do {
      let fetchedData = try tiseAPI?.loadLocalData()
      listings = fetchedData?.listings ?? []
      categories = fetchedData?.categories ?? []
      categories.append(Constants.categoryPlaceholder)
    } catch let error as TiseError {
      errorMessage = error.localizedDescription
      isError.toggle()
      print("⛔️ Failed to refresh data: \(errorMessage)")
    } catch {
      errorMessage = "Unexpected error: \(error.localizedDescription)"
      isError.toggle()
      print("⛔️ Failed to refresh data: \(errorMessage)")
    }
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
      owner: Constants.hardcodedOwner,
      primaryImage: "",
      secondaryImage: ""
    )
    
    do {
      try tiseAPI?.addListing(newListing: newListing)
      print("✅ Added new Listing")
      refreshData()
      return true
    } catch {
      errorMessage = error.localizedDescription
      isError.toggle()
      print("⛔️ Failed to add new Listing")
      return false
    }
  }

  func toggleLiked(for id: String) {
    do {
      try tiseAPI?.toggleLiked(for: id)
      refreshData()
    } catch {
      errorMessage = error.localizedDescription
      isError.toggle()
      print("⛔️ Failed to like item")
    }
  }
}
