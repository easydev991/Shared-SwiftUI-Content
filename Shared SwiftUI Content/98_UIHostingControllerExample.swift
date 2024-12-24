import SwiftUI

// MARK: - Первый вариант

final class DemoRootViewController1: UIViewController {
    init() {
        // Тут инициализируются какие-то важные свойства
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Скрываем навбар при появлении первого экрана
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Показываем навбар при исчезновении первого экрана
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingController = UIHostingController(rootView: DemoRealRootView1())
        addChild(hostingController)
        guard let hostedView = hostingController.view else { return }
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostedView)
        NSLayoutConstraint.activate(
            [
                hostedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                hostedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                hostedView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                hostedView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ]
        )
        hostingController.didMove(toParent: self)
    }
}

struct DemoRealRootView1: View {
    var body: some View {
        NavigationLink(destination: DemoSecondView1()) {
            Text("Открыть второй экран")
        }
    }
}

struct DemoSecondView1: View {
    var body: some View {
        Text("Второй экран")
            .navigationTitle("Второй")
    }
}

@available(iOS 17.0, *)
#Preview("Первый вариант") {
    let rootVC = DemoRootViewController1()
    let navigationController = UINavigationController(rootViewController: rootVC)
    return navigationController
}

// MARK: - Второй вариант

final class DemoRootViewController2: UIViewController {
    init() {
        // Тут инициализируются какие-то важные свойства
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingController = UIHostingController(rootView: DemoRealRootView2())
        addChild(hostingController)
        guard let hostedView = hostingController.view else { return }
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostedView)
        NSLayoutConstraint.activate(
            [
                hostedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                hostedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                hostedView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                hostedView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ]
        )
        hostingController.didMove(toParent: self)
    }
}


struct DemoRealRootView2: View {
    var body: some View {
        NavigationLink(destination: DemoSecondView2()) {
            Text("Открыть второй экран")
        }
        .navigationBarHidden(true) // <- скрыли навбар на первом экране
    }
}

struct DemoSecondView2: View {
    var body: some View {
        Text("Второй экран")
            .navigationTitle("Второй")
            .navigationBarHidden(false) // <- показали навбар на следующем экране
    }
}

@available(iOS 17.0, *)
#Preview("Второй вариант") {
    let rootVC = DemoRootViewController2()
    let navigationController = UINavigationController(rootViewController: rootVC)
    return navigationController
}

// MARK: - Третий вариант

final class DemoRootViewController3<T: View>: UIHostingController<T> {
    override init(rootView: T) {
        // Тут инициализируются какие-то важные свойства
        super.init(rootView: rootView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


struct DemoRealRootView3: View {
    var body: some View {
        NavigationLink(destination: DemoSecondView3()) {
            Text("Открыть второй экран")
        }
        .navigationBarHidden(true) // <- скрыли навбар на первом экране
    }
}

struct DemoSecondView3: View {
    var body: some View {
        Text("Второй экран")
            .navigationTitle("Второй")
            .navigationBarHidden(false) // <- показали навбар на следующем экране
    }
}

@available(iOS 17.0, *)
#Preview("Третий вариант") {
    let suiView = DemoRealRootView3()
    let rootVC = DemoRootViewController3(rootView: suiView)
    let navigationController = UINavigationController(rootViewController: rootVC)
    return navigationController
}

// MARK: - Четвертый вариант

@available(iOS 17.0, *)
#Preview("Четвертый вариант") {
    let suiView = DemoRealRootView3()
    let rootVC = UIHostingController(rootView: suiView)
    let navigationController = UINavigationController(rootViewController: rootVC)
    return navigationController
}
