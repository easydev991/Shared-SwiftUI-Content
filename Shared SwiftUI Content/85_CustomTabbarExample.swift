import UIKit
import SwiftUI

final class CustomUITabbarController: UITabBarController {
    private lazy var viewModel: DemoCustomTabbarView.ViewModel = {
        .init { [weak self] index in
            self?.selectedIndex = index
        }
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, CustomTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tabBar.setupAppearance()

        let suiTabbarView = DemoCustomTabbarView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: suiTabbarView)
        hostingController.view.backgroundColor = .clear
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          hostingController.view.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
          hostingController.view.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
          hostingController.view.heightAnchor.constraint(equalToConstant: 80),
          hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
      }
    
    
    final class CustomTabBar: UITabBar {
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            // Задаем нужную высоту вьюхе таббара
            sizeThatFits.height = 120
            return sizeThatFits
        }
    }
}

extension UITabBar {
    func setupAppearance() {
        let bluredAppearance = UITabBarAppearance()
        bluredAppearance.configureWithTransparentBackground()
        bluredAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        
        bluredAppearance.selectionIndicatorTintColor = .clear
        bluredAppearance.stackedLayoutAppearance.normal.iconColor = .clear
        bluredAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        bluredAppearance.stackedLayoutAppearance.selected.iconColor = .clear
        bluredAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]
        standardAppearance = bluredAppearance
        
        let transparentAppearance = UITabBarAppearance()
        transparentAppearance.configureWithTransparentBackground()
        transparentAppearance.selectionIndicatorTintColor = .clear
        transparentAppearance.stackedLayoutAppearance.normal.iconColor = .clear
        transparentAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        transparentAppearance.stackedLayoutAppearance.selected.iconColor = .clear
        transparentAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]
        scrollEdgeAppearance = transparentAppearance
    }
}

struct DemoCustomTabbarView: View {
    @ObservedObject var viewModel: ViewModel
    private var tabItems: [(Int, Color)] {
        Array(zip(viewModel.demoTabItems.indices, viewModel.demoTabItems))
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(tabItems, id: \.0) { index, color in
                Button {
                    viewModel.selectTab(at: index)
                } label: {
                    Circle().fill(color)
                }
            }
        }
    }
    
    /// Класс для обмена данными с UIKit-вьюхой снаружи,
    /// без него SwiftUI вьюха не будет перерисовываться
    /// при настройке табов снаружи, например
    final class ViewModel: ObservableObject {
        @Published private(set) var demoTabItems: [Color] = [.green, .red, .blue]
        private let didSelectTabAtIndex: (Int) -> Void
        
        init(didSelectTabAtIndex: @escaping (Int) -> Void) {
            self.didSelectTabAtIndex = didSelectTabAtIndex
        }
        
        func selectTab(at index: Int) {
            didSelectTabAtIndex(index)
        }
        
        /// Тут можно настроить свойство demoTabItems,
        /// и вьюха корректно обновится
        func setupTabItems() {}
    }
}

@available(iOS 17.0, *) // Превью для UIKit-вьюх и экранов требует iOS 17+
#Preview {
    let firstVC = UIHostingController(rootView: ViewWithTaskExample())
    let secondVC = UIHostingController(rootView: TransitionExample())
    let thirdVC = UIHostingController(rootView: OnVisibilityChangeExample())
    let tabbarController = CustomUITabbarController()
    tabbarController.viewControllers = [firstVC, secondVC, thirdVC]
    return tabbarController
}
