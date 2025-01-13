import SwiftUI

@main
struct tise_caseApp: App {
  
  @StateObject
  var observable: MainObservable = MainObservable()
  
    var body: some Scene {
        WindowGroup {
          TiseHomeView()
            .environmentObject(observable)
        }
    }
}
