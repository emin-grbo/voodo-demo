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
  @State private var category: Category = Constants.categoryPlaceholder
  @State private var selectedImage: UIImage? = nil
  @State private var selectedItem: PhotosPickerItem? = nil
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("New Tise")
        .font(.largeTitle)
        .padding(.top)
        .bold()
      
      TextEntryCounter(
        placeholder: "Title",
        maxCount: 20,
        text: $title
      )
      
      TextEntryCounter(
        placeholder: "Detail",
        maxCount: 20,
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
              .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius,
                                          style: .continuous))
            }
            .onChange(of: selectedItem) { newItem, _ in
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
#warning("move to constants?")
      // Address input
      TextEntryIcon(
        systemImage: "location.circle.fill",
        placeholder: "Address",
        text: $description
      )
      
      // Category picker
      HStack {
        Image(systemName: "folder.circle.fill")
        Picker(selection: $category, label: Text("Category")) {
          ForEach(observable.categories, id: \.self) { category in
            Text(category.title)
              .tag(category)
          }
        }
        .pickerStyle(MenuPickerStyle())
      }
      
      Spacer()
    }
    .padding()
  }
}

#Preview {
  AddTise()
    .environmentObject(MainObservable())
}
