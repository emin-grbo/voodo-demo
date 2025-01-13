import Foundation

class TiseAPI {
  
  let localJsonData: String = "tech_case_data"
  
  func loadLocalData() -> TiseResponse? {
    guard let url = Bundle.main.url(forResource: localJsonData,
                                    withExtension: "json") else {
      print("File not found")
      return nil
    }
    
    do {
      let data = try Data(contentsOf: url)
      return try JSONDecoder().decode(TiseResponse.self, from: data)
    } catch {
      print("Failed to load or decode JSON: \(error)")
      return nil
    }
  }
}
