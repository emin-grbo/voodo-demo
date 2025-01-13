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
    ScrollView {
      LazyVGrid(columns: columns, spacing: 16) {
          ForEach(listings) { listing in
              Item(listing: listing, baseSize: baseItemSize)
              .onTapGesture {
                observable.selectedItem = listing
                observable.isShowingDetail.toggle()
              }
          }
      }
      .sheet(isPresented: $observable.isShowingDetail) {
        ItemDetail()
      }
    }
    .navigationTitle("Listings")
  }
}
