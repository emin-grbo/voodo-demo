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
          ForEach(listings.sorted {
              let formatter = ISO8601DateFormatter()
              guard let date1 = formatter.date(from: $0.createdAt),
                    let date2 = formatter.date(from: $1.createdAt) else { return false }
              return date1 > date2 // Newest first
          }) { listing in
              Item(listing: listing, baseSize: baseItemSize)
          }
      }
      .padding(.horizontal)
    }
    .navigationTitle("Listings")
  }
}
