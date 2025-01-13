import SwiftUI

struct TiseHomeView: View {
  
  @EnvironmentObject
  var observable: MainObservable
  
  var body: some View {
    TabView {
      ItemList(listings: observable.listings,
               baseItemSize: observable.baseItemSize)
        .tag(0)
        .tabItem {
          Label("Listings", systemImage: "list.bullet.rectangle.fill")
        }
      AddTise()
        .tag(1)
        .tabItem {
          Label("Add Tise", systemImage: "plus.rectangle.fill")
        }
      Profile()
        .tag(2)
        .tabItem {
          Label("Profile", systemImage: "person.crop.rectangle.fill")
        }
    }
    .tint(Color.tiseAccent)
  }
}

#Preview {
  TiseHomeView()
    .environmentObject(MainObservable())
}
