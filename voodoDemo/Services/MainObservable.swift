import Foundation
import SwiftUI

@MainActor
class MainObservable: ObservableObject {
  
  // MARK: Services
  private var demoAPI: VoodoAPI
  
  // MARK: State Control
  @Published var selectedTab: Tabs = .list
  @Published var isShowingDetail = false
  @Published var isShowingError = false
  @Published var selectedItem: Listing?
  
  // MARK: Data Properties
  @Published var listings: [Listing] = []
  @Published var categories: [Category] = []
  
  // MARK: Error handling
  @Published var isError: Bool = false
  @Published var errorMessage: String = "Error Occured"
  
  // MARK: Layout
  var baseItemSize: CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    let spacing: CGFloat = Constants.columnSpacing
    let totalSpacing = spacing * CGFloat(Constants.columnCount + 1)
    return (screenWidth - totalSpacing) / CGFloat(Constants.columnCount)
  }
  
  
  init(api: VoodoAPI = DemoLocalAPI()) {
    
    self.demoAPI = api
    
    Task {
      await refreshData()
    }
  }
  
  func refreshData() async {
    do {
      guard let fetchedData = try await demoAPI.loadLocalData() else { return }
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.listings = fetchedData.listings
        self.categories = fetchedData.categories ?? []
        self.categories.append(Constants.categoryPlaceholder)
      }
    } catch {
      errorMessage = error.localizedDescription
      isError.toggle()
      print("⛔️ Failed to refresh data")
    }
  }
  
  func addListing(
    title: String,
    description: String,
    size: Size,
    category: Category,
    price: String
  ) async {
    
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
      primaryImage: ""
    )
    
    do {
      try await demoAPI.addListing(newListing: newListing)
      print("✅ Added new Listing")
      await refreshData()
    } catch {
      errorMessage = error.localizedDescription
      isError.toggle()
      print("⛔️ Failed to add new Listing")
    }
  }

  func toggleLiked(for id: String) async {
    do {
      try await demoAPI.toggleLiked(for: id)
      await refreshData()
    } catch {
      errorMessage = error.localizedDescription
      isError.toggle()
      print("⛔️ Failed to like item")
    }
  }
}
