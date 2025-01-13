import Foundation

class TiseAPI {
  
  let localJsonDataName: String = "tech_case_data"
  
  func loadLocalData() -> TiseResponse? {
    guard let url = Bundle.main.url(forResource: localJsonDataName,
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
  
  // Add a new listing to the JSON
  func addListing(newListing: Listing) throws {
    guard var localData = loadLocalData() else {
      print("Error adding a new listing")
      throw NSError(domain: "Error Occured", code: 0)
    }
    
    // Append the new listing
    localData.listings.append(newListing)
    
    // Save the updated listings
    return try updateLocalData(with: localData)
  }
  
  // Save JSON data to the app's documents directory
  private func updateLocalData(with data: TiseResponse) throws {
      let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      let fileURL = directory.appendingPathComponent(localJsonDataName)

      do {
          let encoder = JSONEncoder()
          encoder.outputFormatting = .prettyPrinted
        let newData = TiseResponse(listings: data.listings,
                                   categories: data.categories)
        let encodedData = try encoder.encode(newData)
//        let newData = try encoder.encode(["listings": data.listings])
//        let newData = try encoder.encode(["categories": data.categories])
          try encodedData.write(to: fileURL)
        print(try JSONDecoder().decode(TiseResponse.self, from: encodedData))
      } catch {
        throw TiseError.saveError(description: "Failed to save JSON file: \(error)")
      }
  }
}

enum TiseError: Error {
    case dataLoadError(description: String)
    case saveError(description: String)
}
