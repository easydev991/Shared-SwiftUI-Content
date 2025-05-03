import SwiftUI
import OSLog

struct ChangeAppIconExample: View {
    @StateObject private var appIconManager = AppIconManager()

    var body: some View {
        VStack(spacing: 20) {
            ForEach(AppIconVariant.allCases, id: \.self) { icon in
                HStack(spacing: 12) {
                    icon.listImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(.rect(cornerRadius: 20))
                    Text(icon.rawValue)
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if icon.isSelected {
                        Image(systemName: "checkmark")
                            .bold()
                            .transition(
                                .scale
                                    .combined(with: .move(edge: .trailing))
                                    .combined(with: .opacity)
                            )
                    }
                }
                .animation(.default, value: icon.isSelected)
                .contentShape(.rect)
                .onTapGesture {
                    Task { await appIconManager.setIcon(icon) }
                }
            }
        }
        .padding(.horizontal, 50)
    }
}

enum AppIconVariant: String, CaseIterable {
    case primary = "AppIcon"
    case bird = "AppIconBird"
    case swift = "AppIconSwift"

    /// Название альтернативной иконки, для дефолтной иконки всегда `nil`
    var alternateName: String? {
        switch self {
        case .primary: nil
        case .bird: "AppIconBird"
        case .swift: "AppIconSwift"
        }
    }

    /// Уменьшенная картинка (обычный ассет) для отображения в списке
    var listImage: Image {
        switch self {
        case .primary: Image(.defaultAppIcon)
        case .bird: Image(.birdAppIcon)
        case .swift: Image(.swiftAppIcon)
        }
    }

    @MainActor
    var isSelected: Bool {
        alternateName == UIApplication.shared.alternateIconName
    }

    init(name: String?) {
        self = switch name {
        case AppIconVariant.bird.rawValue: .bird
        case AppIconVariant.swift.rawValue: .swift
        default: .primary
        }
    }
}

@MainActor
final class AppIconManager: ObservableObject {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AppIconManager")
    @Published private(set) var currentAppIcon: AppIconVariant?

    init() {
        if let currentIconName = UIApplication.shared.alternateIconName {
            currentAppIcon = AppIconVariant(name: currentIconName)
        }
    }

    func setIcon(_ icon: AppIconVariant) async {
        do {
            guard UIApplication.shared.supportsAlternateIcons else {
                throw IconError.alternateIconsNotSupported
            }
            guard icon.alternateName != UIApplication.shared.alternateIconName else { return }
            try await UIApplication.shared.setAlternateIconName(icon.alternateName)
            currentAppIcon = icon
            logger.info("Установили иконку: \(icon.rawValue)")
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
}

extension AppIconManager {
    enum IconError: Error, LocalizedError {
        case alternateIconsNotSupported

        var errorDescription: String? {
            switch self {
            case .alternateIconsNotSupported:
                "Альтернативные иконки не поддерживаются"
            }
        }
    }
}

#Preview {
    ChangeAppIconExample()
}
