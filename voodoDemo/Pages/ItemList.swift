import SwiftUI

struct ItemList: View {
  
  @EnvironmentObject
  var observable: MainObservable
  
  // Defining number of columns needed
  var columns: [GridItem] {
    Array(repeating: GridItem(.flexible()), count:  Constants.columnCount)
  }
  
  // data
  let listings: [Listing]
  let baseItemSize: CGFloat
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          ForEach(listings) { listing in
            Item(listing: listing, baseSize: baseItemSize)
          }
        }
      }
      .navigationTitle("Listings")
    }
  }
}
