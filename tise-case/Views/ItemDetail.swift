import SwiftUI

struct ItemDetail: View {
  var body: some View {
    //      ZStack {
    VStack {
      // MARK:  top
      
      ProfileHeaderView()
      
      
      
      AsyncImage(url: URL(string: "https://tise-static.telenorcdn.net/61a2523e9b4e8800979b842a/image2/99ab9bb3-008e-4e34-9cf7-a270e7c45652/veronica-stars")) { image in
        ZStack(alignment: .bottomLeading) { // Align content to the bottom
          image
            .resizable()
            .aspectRatio(1, contentMode: .fit) // Maintain a 1:1 aspect ratio
          //                                  .frame(maxHeight: .infinity)       // Take full width of the screen
          
          VStack(alignment: .leading) {
            Text("🙌 Some text 🙌")
            Text("Title here")
              .font(.largeTitle)
            Text("500nok")
          }
          .padding()
          .bold()
          .foregroundStyle(.white)
          //            .background(.black.opacity(0.4))
        }
      } placeholder: {
        Color.gray
          .aspectRatio(1, contentMode: .fit)
          .frame(maxWidth: .infinity)
      }
      .background(Color.black) // Optional background color
      Spacer()
      Text("shnt")
    }
//    .edgesIgnoringSafeArea(.all)
  }
//    }
}

#Preview {
    ItemDetail()
}


struct ProfileHeaderView: View {
  
    var profileImageURL: String = "https://example.com/profile.jpg"
    var username: String = "holzweiler"
    var location: String = "Oslo, Norge"

    var body: some View {
        HStack {
            // Profile Image
            AsyncImage(url: URL(string: profileImageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Circle()
                    .fill(Color.gray)
            }
            .frame(width: 40, height: 40) // Circle size
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 1) // Optional white border
            )

            // Username and Location
            VStack(alignment: .leading, spacing: 2) {
                Text(username)
                    .font(.headline)
                    .fontWeight(.bold)

                Text(location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Action Button
            Button(action: {
              
                // Perform action (e.g., show options menu)
            }) {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal)
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileHeaderView()
  }
}
