import SwiftUI

struct BindingGetSetExample: View {
    /// 1 - свойство для хранения выбранного варианта
    @State private var selectedVariant: String?
    /// 2 - список вариантов, из которых можно выбрать только один
    private let allVariants = (1..<4).map { "Вариант \($0)" }

    var body: some View {
        VStack(spacing: 20) {
            ForEach(allVariants, id: \.self) { variant in
                /// 3 - вьюшка с `binding`-значением
                ToggleView(
                    title: variant,
                    isOn: .init(
                        /// 4 - проверяем, выбран ли вариант
                        get: { isSelected(variant) },
                        /// 5 - выбираем вариант или снимаем выбор
                        set: { select(variant, isOn: $0) }
                    )
                )
            }
        }
        .padding()
    }

    /// 6 - метод для проверки, выбран ли указанный вариант
    private func isSelected(_ variant: String) -> Bool {
        selectedVariant == variant
    }

    /// 7 - метод для выбора/снятия выбора с варианта
    private func select(_ variant: String, isOn: Bool) {
        selectedVariant = isOn ? variant : nil
    }
}

struct ToggleView: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(title, isOn: $isOn)
    }
}

#Preview { BindingGetSetExample() }
