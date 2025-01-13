import SwiftUI

struct ProfileHeaderView: View {
  
  let owner: Owner
  
  var body: some View {
    HStack {
      AsyncImage(url: URL(string: owner.picture)) { image in
        image
          .resizable()
          .scaledToFill()
      } placeholder: {
        Circle()
          .fill(Color.tiseAccent)
      }
      .frame(width: 40, height: 40)
      .clipShape(Circle())
      
      VStack(alignment: .leading, spacing: 2) {
        Text(owner.username)
          .font(.headline)
          .fontWeight(.bold)
        Text("Oslo, Norge")
          .font(.subheadline)
          .foregroundColor(.gray)
      }
      Spacer()
    }
    .padding(.vertical)
  }
}

#Preview {
  ProfileHeaderView(owner: Constants.hardcodedOwner)
}
