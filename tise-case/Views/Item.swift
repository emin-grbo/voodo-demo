import SwiftUI

struct Item: View {
  
  let listing: Listing
  let baseSize: CGFloat
  let sizeCoeficiator: CGFloat = 1.2
  
  var body: some View {
    VStack(alignment: .leading) {
      AsyncImage(url: URL(string: listing.secondaryImage ?? "")) { image in
        image
          .resizable()
          .scaledToFill()
      } placeholder: {
        ZStack {
          Color.tiseAccent
          Image(systemName: "photo.badge.exclamationmark")
            .font(.largeTitle)
            .foregroundStyle(.white)
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
          .foregroundStyle(Color.tiseAccent)
      }
    }
  }
}
