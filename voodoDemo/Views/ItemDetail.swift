import SwiftUI

struct ItemDetail: View {
  
  @EnvironmentObject
  var observable: MainObservable
  
  @State var isLiked = false
  
  let item: Listing
  
  let image: Image?
  
  @State private var imageLoaded = false
  
  var body: some View {
    
    ScrollView {
      VStack(alignment: .leading) {
        
        ProfileHeaderView(owner: item.owner)
          .padding(.top, 24)
        
        if let image = image {
          
          ZStack(alignment: .bottomLeading) {
            image
              .resizable()
              .scaledToFit()
              .scaleEffect(imageLoaded ? 1.0 : 0.1)
              .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.3)) {
                  imageLoaded = true
                }
              }
              .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))
            
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
        } else {
          ZStack {
            Color.demoAccent
            Image(systemName: "photo.badge.exclamationmark")
              .font(.largeTitle)
              .foregroundStyle(.white)
          }
        }
        
        HStack {
          Text("Liked")
            .bold()
          
          Button {
            Task {
              await observable.toggleLiked(for: item.id)
              withAnimation(.easeInOut(duration: 0.2)) {
                isLiked.toggle()
              }
            }
          } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
              .resizable()
              .scaledToFit()
              .frame(width: 24, height: 24)
              .foregroundColor(isLiked ? .demoAccent : .gray)
              .scaleEffect(isLiked ? 1.2 : 1.0)
              .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: isLiked)
          }
          .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical)
        
        Text(item.caption)
      }
      .padding(.horizontal)
    }
    .task {
      isLiked = item.liked
    }
  }
}
