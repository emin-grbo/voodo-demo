import SwiftUI

struct CustomDemoRoundedButtonStyle: ButtonStyle {
  
  init(height: CGFloat = 60,
       radius: CGFloat = Constants.cornerRadius,
       foregroundColor: Color = .white,
       backgroundColor: Color = Color.demoAccent,
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


//Emin Grbo , a bachelor graduate from Singidunum University as of Business Informatics. First half of his career is in marketing, working for a DDB agency between 2006-2012. There he gained experience in print design, animation and web technologies.
//Second part of his professional career focuses on iOS development.  As a member of Core team in TIDAL, he helped maintain app used 5 million users daily.
