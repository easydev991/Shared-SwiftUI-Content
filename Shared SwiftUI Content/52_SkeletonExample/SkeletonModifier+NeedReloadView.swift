import SwiftUI

extension SkeletonModifier {
    /// Вьюшка для отображения ошибки и выполнения перезагрузки данных
    struct NeedReloadView: View {
        private let isVertical: Bool
        private let message: String
        private let action: () -> Void
        
        /// - Parameters:
        ///   - isVertical: `true` - контент располагается вертикально, `false` - горизонтально
        ///   - message: Текст ошибки
        ///   - action: Действие при нажатии на вьюшку
        init(
            isVertical: Bool,
            message: String,
            action: @escaping () -> Void
        ) {
            self.isVertical = isVertical
            self.message = message
            self.action = action
        }
        
        var body: some View {
            content
                .frame(maxHeight: .infinity)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                )
                .onTapGesture(perform: action)
        }
    }
}

extension SkeletonModifier.NeedReloadView {
    private var reloadIconView: some View {
        Image(systemName: "exclamationmark.icloud")
            .resizable()
            .scaledToFit()
            .frame(height: 24)
    }
    
    @ViewBuilder
    private var content: some View {
        if isVertical {
            VStack(spacing: 12) {
                reloadIconView
                Text(message)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
        } else {
            HStack(spacing: 16) {
                Text(message)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                reloadIconView
            }
        }
    }
}
