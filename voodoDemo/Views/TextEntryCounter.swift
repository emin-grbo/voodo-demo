import SwiftUI

struct TextEntryCounter: View {
  let placeholder: String
  let maxCount: Int
  @Binding var text: String
  
  var body: some View {
    TextField(placeholder, text: $text)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .overlay(alignment: .trailing) {
        Text("\(text.count)/\(maxCount)")
          .foregroundColor(.gray)
          .padding(.trailing, 10)
      }
  }
}
