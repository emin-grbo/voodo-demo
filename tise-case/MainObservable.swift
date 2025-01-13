import Foundation
import SwiftUI

class MainObservable: ObservableObject {
  
  // MARK: Services
  var tiseAPI: TiseAPI?
  
  // MARK: Published Properties
  @Published var listings: [Listing]
  @Published var categories: [Category]
  
  // MARK: Layout
  var baseItemSize: CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    let spacing: CGFloat = Constants.columnSpacing
    let totalSpacing = spacing * CGFloat(Constants.columnCount + 1)
    return (screenWidth - totalSpacing) / CGFloat(Constants.columnCount)
  }
  
  init(api: TiseAPI = TiseAPI()) {
    let fetchedData = api.loadLocalData()
    listings = fetchedData?.listings ?? []
    categories = fetchedData?.categories ?? []
  }
}
