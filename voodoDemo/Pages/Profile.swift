import SwiftUI

enum FilterType: String, CaseIterable {
  case liked = "Liked"
  case myItems = "My Items"
}

struct Profile: View {
  
  @EnvironmentObject
  var observable: MainObservable
  
  @State
  private var selectedFilter: FilterType = .liked
  
  let userId: Int = Constants.hardcodedOwner.id ?? 0
  
  var filteredItems: [Listing] {
    switch selectedFilter {
    case .liked:
      return observable.listings.filter { $0.liked }
    case .myItems:
      return observable.listings.filter { $0.owner.id == userId }
    }
  }
  
  var body: some View {
    VStack {
      Picker("Segmented Picker", selection: $selectedFilter) {
        ForEach(FilterType.allCases, id: \.self) { filter in
          Text(filter.rawValue).tag(filter)
        }
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding()
      
      // MARK: No Items found
      if filteredItems.isEmpty {
        VStack {
          Text("Nothing to see here chief! 🤷‍♂️")
            .foregroundStyle(.gray)
        }
        .frame(maxHeight: .infinity)
      } else {
        
        // MARK: List filtered items
        List(filteredItems) { item in
          HStack {
            AsyncImage(url: URL(string: item.primaryImage)) { image in
              image
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(8)
            } placeholder: {
              ZStack {
                Color.demoAccent
                  .frame(width: 50, height: 50)
                  .cornerRadius(8)
                Image(systemName: "photo.badge.exclamationmark")
                  .foregroundStyle(.white)
                  .symbolEffect(.breathe)
              }
            }
            
            VStack(alignment: .leading) {
              Text(item.title)
                .font(.headline)
              Text("\(item.askingPrice) \(item.currency)")
                .font(.subheadline)
                .foregroundColor(.gray)
            }
          }
          .padding(.vertical, 5)
        }
      }
    }
    .navigationTitle("Items")
  }
}

#Preview {
  Profile()
    .environmentObject(MainObservable(appDatabase: .empty()))
}
