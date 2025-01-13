import SwiftUI

struct TiseRoundedButtonStyle: ButtonStyle {
  
  init(height: CGFloat = 60,
       radius: CGFloat = Constants.cornerRadius,
       foregroundColor: Color = .white,
       backgroundColor: Color = Color.tiseAccent,
       fontSize: Font = .body) {
    self.height = height
    self.radius = radius
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
    self.fontSize = fontSize
  }
  
  public let height: CGFloat
  public let radius: CGFloat
  public let foregroundColor: Color
  public let backgroundColor: Color
  public let fontSize: Font
  
  public func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      Image(systemName: "plus.rectangle.fill")
      configuration.label
    }
    .padding()
    .font(.body).bold()
    .frame(maxWidth: .infinity)
    .frame(height: height)
    .background(RoundedRectangle(cornerRadius: radius)
      .fill(backgroundColor))
    .foregroundColor(foregroundColor)
    .font(fontSize.bold())
  }
}
