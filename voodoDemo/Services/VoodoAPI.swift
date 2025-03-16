import Foundation

protocol VoodoAPI {
    func loadLocalData() async throws -> DemoResponse?
    func addListing(newListing: Listing) async throws
    func toggleLiked(for id: String) async throws
}

class DemoLocalAPI: VoodoAPI {
  
  let localJsonDataName: String = "demo_data"
  var localData: DemoResponse? = nil
  
  func loadLocalData() async throws -> DemoResponse? {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = directory.appendingPathComponent("\(localJsonDataName).json")
    
    // Try to load from the documents directory
    if FileManager.default.fileExists(atPath: fileURL.path) {
      do {
        let data = try Data(contentsOf: fileURL)
        let decodedData = try JSONDecoder().decode(DemoResponse.self, from: data)
        localData = decodedData
        return decodedData
      } catch {
        print("Failed to load or decode JSON from documents directory: \(error)")
        throw DemoError.dataLoadError(description: "Failed to load data in \(#function)")
      }
    }
    
    // Fallback to loading from the app bundle
    guard let bundleURL = Bundle.main.url(forResource: localJsonDataName, withExtension: "json") else {
      print("File not found in app bundle")
      return nil
    }
    
    do {
      let data = try Data(contentsOf: bundleURL)
      let decodedData = try JSONDecoder().decode(DemoResponse.self, from: data)
      localData = decodedData
      return decodedData
    } catch {
      print("Failed to load or decode JSON from app bundle: \(error)")
      return nil
    }
  }
  
  // Add a new listing to the JSON
  func addListing(newListing: Listing) async throws {
    guard var localData = try await loadLocalData() else {
      throw DemoError.saveError(description: "⛔️ Failed to add item")
    }
    localData.listings.append(newListing)
    return try updateLocalData(with: localData)
  }
  
  // toggle the selected item, and update the JSON
  func toggleLiked(for listingId: String) async throws {
    if let index = localData?.listings.firstIndex(where: { $0.id == listingId }) {
      localData?.listings[index].liked.toggle()
    }
    guard let newData = localData else {
      throw DemoError.saveError(description: "⛔️ Failed to like item")
    }
    return try updateLocalData(with: newData)
  }
  
}

private extension DemoLocalAPI {
  private func updateLocalData(with data: DemoResponse) throws {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = directory.appendingPathComponent("\(localJsonDataName).json")
    
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let newData = DemoResponse(listings: data.listings,
                                 categories: data.categories)
      let encodedData = try encoder.encode(newData)
      try encodedData.write(to: fileURL)
      localData = newData
      print(try JSONDecoder().decode(DemoResponse.self, from: encodedData))
    } catch {
      throw DemoError.saveError(description: "Failed to save JSON file: \(error)")
    }
  }
}
