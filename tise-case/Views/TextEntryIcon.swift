import SwiftUI

struct TextEntryIcon: View {
    let systemImage: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: systemImage)
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
