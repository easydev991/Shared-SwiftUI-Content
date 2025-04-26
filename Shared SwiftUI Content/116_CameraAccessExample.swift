import SwiftUI

struct CameraAccessExample: View {
    @State private var showSelection = false
    @State private var pickedImage: UIImage?
    @State private var pickerSourceType: UIImagePickerController.SourceType?

    var body: some View {
        VStack {
            if let pickedImage {
                Image(uiImage: pickedImage)
                    .resizable()
                    .scaledToFit()
                    .transition(.scale.combined(with: .slide))
            }
            Button("Добавить фото") {
                showSelection.toggle()
            }
        }
        .animation(.default, value: pickedImage)
        .confirmationDialog(
            "",
            isPresented: $showSelection,
            titleVisibility: .hidden
        ) {
            Button("Сделать фото") {
                pickerSourceType = .camera
            }
            Button("Выбрать из галереи") {
                pickerSourceType = .photoLibrary
            }
        }
        .fullScreenCover(item: $pickerSourceType) { type in
            UIImagePickerRepresentable(
                sourceType: type,
                selectedImage: $pickedImage
            )
            .ignoresSafeArea() // Без этого будут торчать края экрана сверху и снизу
        }
    }
}

extension UIImagePickerController.SourceType: @retroactive Identifiable {
    public var id: String {
        switch self {
        case .camera: "camera"
        case .photoLibrary: "photoLibrary"
        case .savedPhotosAlbum: "savedPhotosAlbum"
        @unknown default: fatalError()
        }
    }
}

#Preview {
    CameraAccessExample()
}
