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
  @State private var category: Category = Category(id: "", title: "Select a category", icon: "no icon")
  @State private var selectedImage: UIImage? = nil
  @State private var showImagePicker = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("New Tise")
        .font(.largeTitle)
        .padding(.top)
        .bold()
      
      TextEntryWithCounter(
        placeholder: "Title",
        maxCount: 20,
        text: $title
      )
      
      TextEntryWithCounter(
        placeholder: "Detail",
        maxCount: 20,
        text: $detail
      )
      
      HStack {
        TextField("Price", text: $price)
          .keyboardType(.numberPad)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Text("NOK")
          .foregroundColor(.gray)
      }
      
      // Image picker
      Button(action: {
        showImagePicker = true
      }) {
        ZStack {
          
          Color.tiseAccent
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
          
          if let image = selectedImage {
            Image(uiImage: image)
              .resizable()
              .scaledToFill()
              .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
              .clipped()
          } else {
            VStack {
              Image(systemName: "camera.fill")
                .font(.largeTitle)
                .padding()
              Text("Tap to select a photo")
            }
            .foregroundColor(.white)
          }
        }
      }
      .sheet(isPresented: $showImagePicker) {
        ImagePicker(image: $selectedImage)
      }
      
      // Description input
      HStack {
        Image(systemName: "pencil.tip.crop.circle.fill")
        TextField("Beskrivelse", text: $description)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      
      // Address input
      HStack {
        Image(systemName: "location.circle.fill")
        TextField("Adresse", text: $address)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      
      // Category picker
      HStack {
        Image(systemName: "folder")
        Picker(selection: $category, label: Text("Kategori")) {
          ForEach(observable.categories, id: \.self) { category in
            Text(category.title)
          }
        }
        .pickerStyle(MenuPickerStyle())
      }
      
      Spacer()
    }
    .padding()
  }
}

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    picker.sourceType = .photoLibrary
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
  
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
      self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      if let uiImage = info[.originalImage] as? UIImage {
        parent.image = uiImage
      }
      picker.dismiss(animated: true)
    }
  }
}

#Preview {
  AddTise()
    .environmentObject(MainObservable())
}
