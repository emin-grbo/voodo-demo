import SwiftUI

enum Tabs {
  case list
  case add
  case profile
}

struct DemoHomeView: View {
  
  @EnvironmentObject
  var observable: MainObservable
  
  var body: some View {
    ZStack {
      
      // MARK: TabView
      
      TabView(selection: $observable.selectedTab) {
        ItemList(listings: observable.listings,
                 baseItemSize: observable.baseItemSize)
        .tag(Tabs.list)
        .tabItem {
          Label("Listings", systemImage: "list.bullet.rectangle.fill")
        }
        AddItem()
          .tag(Tabs.add)
        Profile()
          .tag(Tabs.profile)
          .tabItem {
            Label("Profile", systemImage: "person.crop.rectangle.fill")
          }
      }
      .tint(Color.demoAccent)
      
      // MARK: "Fake" add overlay
      
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
              .background(Circle().fill(Color.demoAccent))
              .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
          }
          .offset(y: -5)
          Spacer()
        }
      }
      .padding(.horizontal, UIScreen.main.bounds.width / 3)
      
    }
    // error alert view
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
  DemoHomeView()
    .environmentObject(MainObservable(appDatabase: .empty()))
}
