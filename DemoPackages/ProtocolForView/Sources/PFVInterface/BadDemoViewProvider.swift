import SwiftUI

/// Протокол для сборщика вашего модуля/экрана
///
/// Содержит плохие с точки зрения производительности варианты создания вьюхи
public protocol BadDemoViewProvider {
    var demoView: AnyView { get }
    func makeDemoView() -> AnyView
    func makeDemoView2() -> any View
}
