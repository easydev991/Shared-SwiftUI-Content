import SwiftUI

/// Протокол для сборщика вашего модуля/экрана
///
/// Для примера содержит два корректных способа получения вьюхи:
/// - вычисляемое свойство
/// - функция
///
/// **Важно**: если в протоколе нужно возвращать типы вьюх (например, `some View`),
/// то для каждой из них нужен свой `associatedType`.
/// Если нужно возвращать одинаковую вьюху, можно использовать один `associatedType`,
/// но при реализации протокола указать в качестве возвращаемого типа
/// один и тот же тип, в нашем случае `DemoView` (тогда вьюху потребуется делать публичной).
@MainActor
public protocol GoodDemoViewProvider {
    /// Пример типа для вычисляемой вьюхи
    associatedtype VarContent: View
    /// Пример типа для вьюхи, получаемой из функции
    associatedtype FuncContent: View
    @ViewBuilder @MainActor var demoView: VarContent { get }
    @ViewBuilder @MainActor func makeDemoView() -> FuncContent
}
