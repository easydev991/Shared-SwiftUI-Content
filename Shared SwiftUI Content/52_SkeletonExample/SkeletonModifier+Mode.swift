import Foundation

extension SkeletonModifier {
    /// Режим скелетона
    enum Mode: Equatable {
        /// Идет загрузка, по скелетону проходит градиент
        case loading
        /// Нужна перезагрузка
        ///
        /// Если данные не удалось загрузить, отображаем заданный текст
        /// и при нажатии повторно пробуем загрузить данные
        case needReload(ReloadModel)
        
        struct ReloadModel: Equatable {
            static func == (
                lhs: SkeletonModifier.Mode.ReloadModel,
                rhs: SkeletonModifier.Mode.ReloadModel
            ) -> Bool {
                lhs.message == rhs.message
            }
            
            let message: String
            let action: () -> Void
            
            /// - Parameters:
            ///   - message: Сообщение для отображения
            ///   - action: Действие при нажатии на вьюшку, должно повторно запускать загрузку
            init(message: String, action: @escaping () -> Void) {
                self.message = message
                self.action = action
            }
        }
    }
}
