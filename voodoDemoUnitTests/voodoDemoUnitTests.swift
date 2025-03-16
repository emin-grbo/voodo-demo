import Testing
import XCTest
import SwiftUI
@testable import voodoDemo

struct voodoDemoUnitTests {
  
  let mockAPI = DemoLocalAPI()
  
  @Test func testLoadLocalData() async throws {
    
    let mainObservable =
    await MainActor.run {
      MainObservable(api: mockAPI)
    }
    
    await mainObservable.refreshData()
    
    await MainActor.run {
      XCTAssertFalse(mainObservable.listings.isEmpty, "Listings should not be empty after loading local data")
      XCTAssertFalse(mainObservable.categories.isEmpty, "Categories should not be empty after loading local data")
    }
  }
  
  @Test func testAddListing() async throws {
    
    let mainObservable = await MainActor.run {
      MainObservable(api: mockAPI)
    }
    
    let initialCount = await MainActor.run { mainObservable.listings.count }
    
    // Act: Add a new listing
    await mainObservable.addListing(
      title: "Test Item",
      description: "Test Description",
      size: .M,
      category: Category(id: "test", title: "test", icon: "test") ,
      price: "100"
    )
    
    // Assert: Verify the count increased
    await MainActor.run {
      XCTAssertEqual(mainObservable.listings.count, initialCount + 1, "New listing should be added")
    }
  }

@Test func testToggleLiked() async throws {
  
    let mainObservable = await MainActor.run {
        MainObservable(api: mockAPI)
    }

    await mainObservable.refreshData()
  
  await MainActor.run {
    
    guard let firstListing = mainObservable.listings.first else {
      XCTFail("No listings available to toggle like")
      return
    }

    let initialLikedState = firstListing.liked

    // Act: Toggle liked state
    Task {
     await mainObservable.toggleLiked(for: firstListing.id)
    }

    // Assert: Ensure the liked state has changed
        XCTAssertNotEqual(mainObservable.listings.first?.liked, initialLikedState, "Liked state should toggle")
  }
}
}
