import SwiftUI

enum BlurExample {
    static let regularItems = Array(
        stride(
            from: CGFloat(0.01),
            through: CGFloat(0.2),
            by: 0.005
        )
    )
    static let extraItems = Array(
        stride(
            from: CGFloat(0.01),
            through: CGFloat(4),
            by: 0.1
        )
    )
}

struct UIVisialEffectViewRepresentable: UIViewRepresentable {
    let effect: UIVisualEffect
    let intensity: CGFloat
    
    init(effect: UIVisualEffect, intensity: CGFloat) {
        self.effect = effect
        self.intensity = intensity
    }
    
    func makeUIView(context: Context) -> some UIView {
        CustomIntensityVisualEffectView(effect: effect, intensity: intensity)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

/// Визуальный эффект с заданной интенсивностью
private final class CustomIntensityVisualEffectView: UIVisualEffectView {
    private var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    
    /// Инициализатор
    /// - Parameters:
    ///   - effect: Визуальный эффект, например `UIBlurEffect(style: .dark)`
    ///   - intensity: Интенсивность эффекта, где `0.0` - отсутствие эффекта, а `1.0` - полный эффект
    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator.addAnimations { [weak self] in
            self?.effect = effect
        }
        animator.fractionComplete = intensity
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview("SwiftUI_blur_1") {
    ScrollView {
        VStack(spacing: 0) {
            ForEach(BlurExample.regularItems, id: \.self) { level in
                Text("Степень размытия \(level)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(
                        UIVisialEffectViewRepresentable(
                            effect: UIBlurEffect(style: .dark),
                            intensity: level
                        )
                    )
            }
        }
    }
}

#Preview("SwiftUI_blur_2") {
    ScrollView {
        VStack(spacing: 0) {
            ForEach(BlurExample.regularItems, id: \.self) { level in
                Text("Степень размытия \(level)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .blur(radius: level)
            }
        }
    }
}

#Preview("SwiftUI_blur_3") {
    ScrollView {
        VStack(spacing: 0) {
            ForEach(BlurExample.extraItems, id: \.self) { level in
                Text("Степень размытия \(level)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .blur(radius: level)
            }
        }
    }
}
