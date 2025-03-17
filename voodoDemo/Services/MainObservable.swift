import Foundation
import SwiftUI
import GRDB

@MainActor
class MainObservable: ObservableObject {
  
  // MARK: Services
  private var demoAPI: VoodoAPI
  
  private let appDatabase: AppDatabase
  @ObservationIgnored private var cancellable: AnyDatabaseCancellable?
  
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
  
  init(api: VoodoAPI = DemoLocalAPI(), appDatabase: AppDatabase) {
    
    self.appDatabase = appDatabase /// not yet active, just present if needed with example data
    self.demoAPI = api /// using local DEMO data for ease of use and freedom to verify/test excluding network conditions
    
    // Loading the data as soon as the app launches. If there is Onboardnig present, this can be delayed.
    Task {
      await refreshData()
    }
  }
  
  /// Refreshes the data by fetching local demo data from the API.
  /// Updates listings and categories in the observable state.
  func refreshData() async {
    do {
      // Attempt to fetch data from the local demo API
      guard let fetchedData = try await demoAPI.loadLocalData() else { return }
      
      // Update the state on the main thread
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.listings = fetchedData.listings
        
        // Update categories and add a placeholder if needed
        self.categories = fetchedData.categories ?? []
        self.categories.append(Constants.categoryPlaceholder)
      }
    } catch {
      // Handle any errors and display an error message
      errorMessage = error.localizedDescription
      isError.toggle()
      print("⛔️ Failed to refresh data")
    }
  }
  
  /// Adds a new listing with the provided details.
  /// After successfully adding, it refreshes the data.
  func addListing(
    title: String,
    description: String,
    size: Size,
    category: Category,
    price: String
  ) async {
    
    // Create a new listing object
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
      
      // Refresh the data to include the new listing
      await refreshData()
      
    } catch {
      // Handle any errors and display an error message
      errorMessage = error.localizedDescription
      isError.toggle()
      print("⛔️ Failed to add new Listing")
    }
  }

  /// Toggles the "liked" state of an item with the given ID.
  /// After updating, it refreshes the data.
  func toggleLiked(for id: String) async {
    do {
      try await demoAPI.toggleLiked(for: id)
      await refreshData()
    } catch {
      // Handle any errors and display an error message
      errorMessage = error.localizedDescription
      isError.toggle()
      print("⛔️ Failed to like item")
    }
  }
}
