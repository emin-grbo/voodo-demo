import SwiftUI

struct ItemList: View {
  
  @EnvironmentObject
  var observable: MainObservable
  
  var columns: [GridItem] {
    Array(repeating: GridItem(.flexible()), count:  Constants.columnCount)
  }
  
  let listings: [Listing]
  let baseItemSize: CGFloat
  
  var body: some View {
      NavigationStack {
        ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          ForEach(listings) { listing in
//            NavigationLink(value: listing) {
              Item(listing: listing, baseSize: baseItemSize)
//            }
          }
        }
      }
      .navigationTitle("Listings")
//      .navigationDestination(for: Listing.self) { listing in
//        ItemDetail(item: listing)
//      }
    }
  }
}
