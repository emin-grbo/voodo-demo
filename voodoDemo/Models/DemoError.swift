import Foundation

enum DemoError: Error, LocalizedError {
  case dataLoadError(description: String)
  case saveError(description: String)
  
  var errorDescription: String? {
    switch self {
    case .dataLoadError(let description), .saveError(let description):
      return description
    }
  }
}
