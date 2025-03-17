import SwiftUI
import PhotosUI

struct AddItem: View {
  
  @EnvironmentObject
  var observable: MainObservable
  
  @State private var title: String = ""
  @State private var detail: String = ""
  @State private var price: String = ""
  @State private var description: String = ""
  @State private var selectedCategory: Category = Constants.categoryPlaceholder
  @State private var selectedSize: Size = .notApplicable
  @State private var selectedImage: UIImage? = nil
  @State private var selectedItem: PhotosPickerItem? = nil
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Text("New Item")
          .font(.largeTitle)
          .padding(.top)
          .bold()
        
        // MARK: Photo preview
        
        if let image = selectedImage {
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius,
                                        style: .continuous))
            .clipped()
        } else {
          
          // MARK: Photo selector/preview
          
          PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
          ) {
            ZStack {
              Color.demoAccent
              VStack {
                Image(systemName: "camera.shutter.button.fill")
                  .symbolEffect(.wiggle)
                  .font(.largeTitle)
                  .padding()
                Text("Tap to select a cover photo")
              }
              .foregroundColor(.white)
            }
            .frame(height: UIScreen.main.bounds.width * 0.7)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius,
                                        style: .continuous))
          }
          .onChange(of: selectedItem) { _, newItem in
            if let newItem = newItem {
              Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                  selectedImage = uiImage
                }
              }
            }
          }
        }
        
        // Title input
        TextEntryIcon(
          systemImage: "inset.filled.square.dashed",
          placeholder: "Title",
          maxCount: 20,
          text: $title
        )
        
        // Detail text input
        TextEntryIcon(
          systemImage: "square.text.square.fill",
          placeholder: "Detail",
          maxCount: 20,
          text: $detail
        )
        
        // Price input
        HStack {
        TextEntryIcon(
          systemImage: "dollarsign.square.fill",
          placeholder: "Price",
          text: $price
        )
        .keyboardType(.numberPad)
          
          Text(Constants.defaultCurrency)
            .foregroundColor(.gray)
      }
        
        // Description input
        TextEntryIcon(
          systemImage: "pencil.tip.crop.circle.fill",
          placeholder: "Description",
          text: $description
        )
        
        // Category picker
        HStack {
          Image(systemName: "tag.square.fill")
            .foregroundStyle(Color.demoAccent)
          Picker(selection: $selectedCategory, label: Text("Category")) {
            ForEach(observable.categories, id: \.self) { category in
              Text(category.title)
                .tag(category)
            }
          }
          .pickerStyle(MenuPickerStyle())
          .tint(Color.demoAccent)
        }
        
        // Size picker
        HStack {
          Image(systemName: "arrow.down.backward.and.arrow.up.forward.square.fill")
            .foregroundStyle(Color.demoAccent)
          Picker(selection: $selectedSize, label: Text("Category")) {
            ForEach(Size.allCases, id: \.self) { size in
              Text(size.rawValue)
                .tag(size)
            }
          }
          .pickerStyle(MenuPickerStyle())
          .tint(Color.demoAccent)
        }
        
        // Add item button
        Button("Add Item") {
          Task {
            await observable.addListing(
              title: title,
              description: description,
              size: selectedSize,
              category: selectedCategory,
              price: price)
            cleanup()
          }
        }
        .buttonStyle(CustomDemoRoundedButtonStyle())
        .padding(.bottom, 24)
      }
      .padding()
    }
  }
  
  // Used to "clean" the view by nullifying all fields
  private func cleanup() {
    title = ""
    detail = ""
    description = ""
    price = ""
    description = ""
    selectedCategory = Constants.categoryPlaceholder
    selectedSize = .notApplicable
    selectedItem = nil
    selectedImage = nil
    observable.selectedTab = .list
  }
}

#Preview {
  AddItem()
    .environmentObject(MainObservable(appDatabase: .empty()))
}
