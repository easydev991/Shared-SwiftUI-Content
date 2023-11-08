import SwiftUI
import UIKit

struct UIImagePickerRepresentable: UIViewControllerRepresentable {
    @Binding private var selectedImage: UIImage?
    private let sourceType: UIImagePickerController.SourceType

    init(
        sourceType: UIImagePickerController.SourceType = .photoLibrary,
        selectedImage: Binding<UIImage?>
    ) {
        self.sourceType = sourceType
        self._selectedImage = selectedImage
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { .init(self) }
}

extension UIImagePickerRepresentable {
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let parent: UIImagePickerRepresentable

        init(_ parent: UIImagePickerRepresentable) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            picker.dismiss(animated: true) { [weak self] in
                if let image = info[.editedImage] as? UIImage {
                    self?.parent.selectedImage = image
                }
            }
        }
    }
}

struct PickImageExample: View {
    @State private var pickedImage: UIImage?
    @State private var showPicker = false
    
    var body: some View {
        VStack {
            if let pickedImage {
                Image(uiImage: pickedImage)
                    .resizable()
                    .scaledToFit()
                    .transition(.scale.combined(with: .slide))
            }
            Button("Открыть галерею") {
                showPicker = true
            }
            .sheet(isPresented: $showPicker) {
                UIImagePickerRepresentable(selectedImage: $pickedImage)
            }
        }
        .animation(.default, value: pickedImage)
    }
}

#Preview { PickImageExample() }
