import SwiftUI

struct TextEntryIcon: View {
  let systemImage: String
  let placeholder: String
  var maxCount: Int = 0
  @Binding var text: String
  
  var body: some View {
    HStack {
      Image(systemName: systemImage)
        .foregroundStyle(Color.demoAccent)
      TextField(placeholder, text: $text)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .overlay(alignment: .trailing) {
          if maxCount > 0 {
            Text("\(text.count)/\(maxCount)")
              .foregroundColor(.gray)
              .padding(.trailing, 10)
          }
        }
    }
  }
}
