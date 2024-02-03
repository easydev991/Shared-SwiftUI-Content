import SwiftUI

struct SkeletonExample: View {
    @State private var state = ScreenState.loading
    private let shouldFail: Bool
    private let height: CGFloat
    
    init(shouldFail: Bool, height: CGFloat) {
        self.shouldFail = shouldFail
        self.height = height
    }
    
    private var reloadModel: SkeletonModifier.Mode.ReloadModel? {
        if case .error = state {
            .init(
                message: "Не удалось загрузить данные, нажмите для перезагрузки",
                action: simulateRequest
            )
        } else {
            nil
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .overlay {
                Text("Контент для вьюшки")
                    .foregroundStyle(.white)
            }
            .onAppear { simulateRequest() }
            .skeleton(if: state == .loading, reloadModel: reloadModel)
    }
    
    func simulateRequest() {
        state = .loading
        Task {
            try? await Task.sleep(for: .seconds(2))
            state = shouldFail ? .error : .success
        }
    }
}

extension SkeletonExample {
    enum ScreenState {
        case loading, error, success
    }
}

#Preview("Ошибка") {
    VStack(spacing: 20) {
        SkeletonExample(shouldFail: true, height: 64)
        SkeletonExample(shouldFail: true, height: 110)
    }
    .padding()
}

#Preview("Успех") {
    VStack(spacing: 20) {
        SkeletonExample(shouldFail: false, height: 64)
        SkeletonExample(shouldFail: false, height: 110)
    }
    .padding()
}

#Preview("Разные варианты") {
    ScrollView {
        VStack(spacing: 20) {
            ForEach(1..<4, id: \.self) { id in
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .skeleton(if: true, reloadModel: nil)
            }
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .skeleton(
                    if: false,
                    reloadModel: .init(
                        message: "Горизонтальная вьюшка. Ошибка загрузки.",
                        action: { print("Пробуем загрузить снова 1") }
                    )
                )
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .skeleton(
                    if: false,
                    reloadModel: .init(
                        message: "Вертикальная вьюшка (т.к. высота больше 100). Не удалось загрузить данные",
                        action: { print("Пробуем загрузить снова 2") }
                    )
                )
        }
        .padding(.horizontal)
    }
}
