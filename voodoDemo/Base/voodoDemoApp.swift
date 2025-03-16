import SwiftUI

@main
struct voodoDemoApp: App {
  
  @StateObject
  var observable: MainObservable = MainObservable()
  
    var body: some Scene {
        WindowGroup {
          DemoHomeView()
            .environmentObject(observable)
        }
    }
}
