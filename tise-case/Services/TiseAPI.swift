import Foundation

class TiseAPI {
  
  let localJsonDataName: String = "tech_case_data"
  var localData: TiseResponse? = nil
  
  func loadLocalData() throws -> TiseResponse? {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = directory.appendingPathComponent("\(localJsonDataName).json")
    
    // Try to load from the documents directory
    if FileManager.default.fileExists(atPath: fileURL.path) {
      do {
        let data = try Data(contentsOf: fileURL)
        let decodedData = try JSONDecoder().decode(TiseResponse.self, from: data)
        localData = decodedData
        return decodedData
      } catch {
        print("Failed to load or decode JSON from documents directory: \(error)")
        throw TiseError.dataLoadError(description: "Failed to load data in \(#function)")
      }
    }
    
    // Fallback to loading from the app bundle
    guard let bundleURL = Bundle.main.url(forResource: localJsonDataName, withExtension: "json") else {
      print("File not found in app bundle")
      return nil
    }
    
    do {
      let data = try Data(contentsOf: bundleURL)
      let decodedData = try JSONDecoder().decode(TiseResponse.self, from: data)
      localData = decodedData
      return decodedData
    } catch {
      print("Failed to load or decode JSON from app bundle: \(error)")
      return nil
    }
  }
  
  // Add a new listing to the JSON
  func addListing(newListing: Listing) throws {
    guard var localData = try loadLocalData() else {
      throw TiseError.saveError(description: "⛔️ Failed to add item")
    }
    localData.listings.append(newListing)
    return try updateLocalData(with: localData)
  }
  
  // toggle the selected item, and update the JSON
  func toggleLiked(for listingId: String) throws {
    if let index = localData?.listings.firstIndex(where: { $0.id == listingId }) {
      localData?.listings[index].liked.toggle()
    }
    guard let newData = localData else {
      throw TiseError.saveError(description: "⛔️ Failed to like item")
    }
    try updateLocalData(with: newData)
  }
  
}

private extension TiseAPI {
  private func updateLocalData(with data: TiseResponse) throws {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = directory.appendingPathComponent("\(localJsonDataName).json")
    
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let newData = TiseResponse(listings: data.listings,
                                 categories: data.categories)
      let encodedData = try encoder.encode(newData)
      try encodedData.write(to: fileURL)
      localData = newData
      print(try JSONDecoder().decode(TiseResponse.self, from: encodedData))
    } catch {
      throw TiseError.saveError(description: "Failed to save JSON file: \(error)")
    }
  }
}
