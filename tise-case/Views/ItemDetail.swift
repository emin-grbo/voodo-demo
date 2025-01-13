import SwiftUI

struct ItemDetail: View {
  
  @EnvironmentObject
  var observable: MainObservable
  
  @State var isLiked = false
  
  var body: some View {
    
    // setting the current selected item for easier use in the code below
    let item = observable.selectedItem!
    
    ScrollView {
      VStack(alignment: .leading) {
        
        ProfileHeaderView(owner: item.owner)
          .padding(.top, 24)
        
        AsyncImage(url: URL(string: item.secondaryImage ?? "")) { image in
          ZStack(alignment: .bottomLeading) {
            image
              .resizable()
              .scaledToFit()
            
            VStack(alignment: .leading) {
              Text(item.title)
                .font(.largeTitle)
              Text("\(item.askingPrice)\(item.currency)")
            }
            .padding()
            .bold()
            .foregroundStyle(.white)
            .shadow(color: .gray.opacity(0.8), radius: 10, x: 0, y: 5)
          }
        } placeholder: {
          Color.tiseAccent
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: .infinity)
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))
        
        HStack {
          Text("Liked")
            .bold()
          LikeButton(isLiked: $isLiked)
        }
        .padding(.vertical)
        
        Text(item.caption)
      }
      .padding(.horizontal)
    }
    .task {
      isLiked = item.liked
      print(item)
    }
    .onDisappear {
      observable.toggleLiked(for: item.id)
    }
  }
}
