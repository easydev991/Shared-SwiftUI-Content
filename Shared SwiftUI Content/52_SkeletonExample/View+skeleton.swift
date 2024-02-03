import SwiftUI

extension View {    
    /// Добавляет модификатор со скелетоном
    /// - Parameters:
    ///   - loading: `true` - скелетон нужен, `false` - не нужен
    ///   - reloadModel: Модель с данными для повторной загрузки (сообщение и действие)
    ///   - cornerRadius: Радиус углов скелетона, по дефолту 16
    func skeleton(
        if loading: Bool,
        reloadModel: SkeletonModifier.Mode.ReloadModel?,
        cornerRadius: CGFloat = 16
    ) -> some View {
        var mode: SkeletonModifier.Mode?
        if let reloadModel {
            mode = .needReload(reloadModel)
        } else if loading {
            mode = .loading
        }
        return modifier(
            SkeletonModifier(mode: mode, cornerRadius: cornerRadius)
        )
    }
}
