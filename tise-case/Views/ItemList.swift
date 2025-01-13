import SwiftUI

struct ItemList: View {
  
  var columns: [GridItem] {
    Array(repeating: GridItem(.flexible()), count:  Constants.columnCount)
  }
  
  let listings: [Listing]
  let baseItemSize: CGFloat
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 16) {
        ForEach(listings) { listing in
          Item(listing: listing, baseSize: baseItemSize)
        }
      }
      .padding(.horizontal)
    }
    .navigationTitle("Listings")
  }
}
