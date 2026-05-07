import SwiftUI

struct LikeButton: View {
  
  @Binding var isLiked: Bool
  
  var body: some View {
    Button(action: {
      withAnimation(.easeInOut(duration: 0.2)) {
        isLiked.toggle()
      }
    }) {
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
}
