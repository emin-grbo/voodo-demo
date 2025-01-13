import SwiftUI
import PhotosUI

struct AddTise: View {
  
  @EnvironmentObject
  var observable: MainObservable
  
  @State private var title: String = ""
  @State private var detail: String = ""
  @State private var price: String = ""
  @State private var description: String = ""
  @State private var address: String = ""
  @State private var selectedCategory: Category = Constants.categoryPlaceholder
  @State private var selectedSize: Size = .notApplicable
  @State private var selectedImage: UIImage? = nil
  @State private var selectedItem: PhotosPickerItem? = nil
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Text("New Tise")
          .font(.largeTitle)
          .padding(.top)
          .bold()
        
        TextEntryCounter(
          placeholder: "Title",
          maxCount: Constants.maxCharCount,
          text: $title
        )
        
        TextEntryCounter(
          placeholder: "Detail",
          maxCount: Constants.maxCharCount,
          text: $detail
        )
        
        HStack {
          TextField("Price", text: $price)
            .keyboardType(.numberPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          Text(Constants.defaultCurrency)
            .foregroundColor(.gray)
        }
        
        // MARK: Photo selector/preview
        if let image = selectedImage {
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius,
                                        style: .continuous))
            .clipped()
        } else {
          PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
          ) {
            ZStack {
              Color.tiseAccent
              VStack {
                Image(systemName: "camera.fill")
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
        
        // Description input
        TextEntryIcon(
          systemImage: "pencil.tip.crop.circle.fill",
          placeholder: "Description",
          text: $description
        )
        
        // Address input
        TextEntryIcon(
          systemImage: "location.circle.fill",
          placeholder: "Address",
          text: $address
        )
        
        // Category picker
        HStack {
          Image(systemName: "folder.circle.fill")
          Picker(selection: $selectedCategory, label: Text("Category")) {
            ForEach(observable.categories, id: \.self) { category in
              Text(category.title)
                .tag(category)
            }
          }
          .pickerStyle(MenuPickerStyle())
          .tint(Color.tiseAccent)
        }
        
        // Size picker
        HStack {
          Image(systemName: "folder.circle.fill")
          Picker(selection: $selectedSize, label: Text("Category")) {
            ForEach(Size.allCases, id: \.self) { size in
              Text(size.rawValue)
                .tag(size)
            }
          }
          .pickerStyle(MenuPickerStyle())
          .tint(Color.tiseAccent)
        }
        
        Button("Add Tise") {
          if observable.addListing(
            title: title,
            description: description,
            size: selectedSize,
            category: selectedCategory,
            price: price
          ) {
            cleanup()
          } else {
            print("⛔️ Error saving item")
          }
        }
        .buttonStyle(TiseRoundedButtonStyle())
        .padding(.bottom, 24)
      }
      .padding()
    }
  }
  
  private func cleanup() {
    title = ""
    detail = ""
    description = ""
    price = ""
    description = ""
    address = ""
    selectedCategory = Constants.categoryPlaceholder
    selectedSize = .notApplicable
    selectedItem = nil
    selectedImage = nil
    observable.selectedTab = .list
  }
}

#Preview {
  AddTise()
    .environmentObject(MainObservable())
}
