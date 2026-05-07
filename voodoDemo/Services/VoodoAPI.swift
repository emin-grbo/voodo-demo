import Foundation

protocol VoodoAPI {
    func loadLocalData() async throws -> DemoResponse?
    func addListing(newListing: Listing) async throws
    func toggleLiked(for id: String) async throws
}

// DemoLocalAPI is used for it's versatility and ease of testing. Its role is tho fake a remote API while using simple local JSON file. VoodoAPI protocol is the same protocol that would be used to define remote API.
// To that end, once the app is ready or production we would simply inject the true API instead of the local one.

class DemoLocalAPI: VoodoAPI {
  
  let localJsonDataName: String = "demo_data" // actual name of the mock data JSON
  var localData: DemoResponse? = nil
  
  // Loads data from the documents directory if present. This will fail the first time, as file is located in the app binary initialy. Once fetched from the appBinary it will be saved and refferenced from documentsDirectory as long is the app in installed on the phone.
  // Benefit of this is that test data is wiped each time we de-install/install the app.
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

// The only method which does not refer to the remote API and as such is not part of the procotol.
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
