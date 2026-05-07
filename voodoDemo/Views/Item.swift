import SwiftUI

struct Item: View {
  
  let listing: Listing
  let baseSize: CGFloat
  let sizeCoeficiator: CGFloat = 1.2
  
  @State private var loadedImage: Image?
  
  var body: some View {
    NavigationLink(destination: ItemDetail(item: listing,
                                           image: loadedImage)) {
      VStack(alignment: .leading) {
        AsyncImage(url: URL(string: listing.primaryImage)) { phase in
          switch phase {
          case .success(let image):
            image
              .resizable()
              .scaledToFill()
              .onAppear { loadedImage = image }
          case .failure:
            ZStack {
              Color.demoAccent
              Image(systemName: "photo.badge.exclamationmark")
                .font(.largeTitle)
                .foregroundStyle(.white)
            }
          default:
            ZStack {
              Color.demoAccent.opacity(0.2)
              Image(systemName: "photo.badge.arrow.down.fill")
                .symbolEffect(.breathe)
                .font(.largeTitle)
                .foregroundStyle(Color.demoAccent)
            }
          }
        }
        .frame(width: baseSize,
               height: baseSize * sizeCoeficiator)
        .clipShape(
          RoundedRectangle(
            cornerRadius: Constants.cornerRadius,
            style: .continuous
          )
        )
        .clipped()
        
        Text(listing.title)
          .font(.headline)
          .lineLimit(1)
        
        HStack {
          Text(listing.size)
            .foregroundColor(.gray)
          Text("•")
          Text("\(listing.askingPrice) \(listing.currency)")
            .font(.subheadline)
            .bold()
            .foregroundStyle(Color.demoAccent)
        }
      }
    }
    .buttonStyle(PlainButtonStyle())
  }
}
