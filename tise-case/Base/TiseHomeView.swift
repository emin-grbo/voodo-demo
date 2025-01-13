import SwiftUI

enum Tabs {
  case list
  case add
  case profile
}

struct TiseHomeView: View {
  
  @EnvironmentObject
  var observable: MainObservable
  
  var body: some View {
    ZStack {
      
      TabView(selection: $observable.selectedTab) {
        ItemList(listings: observable.listings,
                 baseItemSize: observable.baseItemSize)
        .tag(Tabs.list)
        .tabItem {
          Label("Listings", systemImage: "list.bullet.rectangle.fill")
        }
        AddTise()
          .tag(Tabs.add)
        Profile()
          .tag(Tabs.profile)
          .tabItem {
            Label("Profile", systemImage: "person.crop.rectangle.fill")
          }
      }
      .tint(Color.tiseAccent)
      
      VStack {
        Spacer()
        HStack {
          Spacer()
          Button(action: {
            observable.selectedTab = .add
          }) {
            Image(systemName: "plus")
              .resizable()
              .scaledToFit()
              .frame(width: 30, height: 30)
              .foregroundColor(.white)
              .padding()
              .background(Circle().fill(Color.tiseAccent))
              .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
          }
          .offset(y: -5)
          Spacer()
        }
      }
      .padding(.horizontal, UIScreen.main.bounds.width / 3)
    }
    .alert(isPresented: $observable.isError) {
      Alert(
        title: Text("Error occurred"),
        message: Text(observable.errorMessage),
        dismissButton: .default(Text("Dismiss"))
      )
    }
  }
}

#Preview {
  TiseHomeView()
    .environmentObject(MainObservable())
}
