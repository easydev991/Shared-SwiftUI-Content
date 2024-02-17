import SwiftUI

final class VCExampleForPreview: UIViewController {
    private let model: Model
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                imageView,
                firstLabel,
                secondLabel,
                actionButton
            ]
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .vertical
        stack.setCustomSpacing(30, after: actionButton)
        stack.spacing = 16
        return stack
    }()
    
    private var imageView: UIImageView {
        let view = UIImageView()
        view.image = .init(systemName: model.imageName)
        view.tintColor = .black
        return view
    }
    
    private var firstLabel: UILabel {
        let label = UILabel()
        label.text = model.title
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }
    
    private var secondLabel: UILabel {
        let label = UILabel()
        label.text = model.subtitle
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }
    
    private lazy var actionButton: UIButton = {
        .init(
            configuration: .borderedProminent(),
            primaryAction: .init(
                title: model.buttonTitle,
                handler: { _ in print("Нажали на кнопку!") }
            )
        )
    }()
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        let demoItems = model.listItems.map { text -> UIView in
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
            return label
        }
        demoItems.forEach(stackView.addArrangedSubview)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
}

extension VCExampleForPreview {
    /// Модель с данными для отображения на экране
    struct Model {
        let title, subtitle, buttonTitle, imageName: String
        let listCount: Int
        
        var listItems: [String] {
            (0..<listCount).map {
                "Элемент # \($0) для экрана \(title) "
            }
        }
        
        static let optionA = Self(
            title: "Профиль",
            subtitle: "Информация о пользователе",
            buttonTitle: "Загрузить профиль",
            imageName: "person.fill",
            listCount: 10
        )
        
        static let optionB = Self(
            title: "Настройки",
            subtitle: "Кастомизация приложения",
            buttonTitle: "Сбросить настройки",
            imageName: "gear",
            listCount: 5
        )
    }
}

// MARK: - iOS 17
//#Preview("Профиль") {
//    VCExampleForPreview(model: .optionA)
//}
//
//#Preview("Настройки") {
//    VCExampleForPreview(model: .optionB)
//}

// MARK: - iOS < 17

struct UIKitPreviewExample: UIViewControllerRepresentable {
    let model: VCExampleForPreview.Model
    
    init(model: VCExampleForPreview.Model = .optionA) {
        self.model = model
    }
    
    func makeUIViewController(context: Context) -> VCExampleForPreview {
        .init(model: model)
    }
    
    func updateUIViewController(_ uiViewController: VCExampleForPreview, context: Context) {}
}

#Preview("Профиль") {
    UIKitPreviewExample(model: .optionA)
}

#Preview("Настройки") {
    UIKitPreviewExample(model: .optionB)
}

// MARK: iOS < 17, Xcode < 15
//struct OldPreviewExample: PreviewProvider {
//    static var previews: some View {
//        Group {
//            UIKitPreviewExample(model: .optionA)
//                .previewDisplayName("Профиль")
//            UIKitPreviewExample(model: .optionB)
//                .previewDisplayName("Настройки")
//        }
//    }
//}
