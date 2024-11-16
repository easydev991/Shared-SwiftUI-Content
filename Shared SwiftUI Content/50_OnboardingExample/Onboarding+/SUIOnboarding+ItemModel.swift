import Foundation

extension SUIOnboarding {
    /// Модель элемента экрана для онбординга
    public struct ItemModel: Hashable, Sendable {
        /// Используется в качестве ключа в словаре со всеми элементами
        public let id: String
        let step: Step
        public let orderID: Int
        public let title: String
        public let message: String
        public let maskPadding: CGFloat
        let hideNavigationTitle: Bool
        public let isIgnored: Bool
        
        var isFirstExtra: Bool {
            if case .extraFirst = step { true } else { false }
        }
        
        /// Обычный инициализатор
        /// - Parameters:
        ///   - id: Уникальный идентификатор шага онбординга
        ///   - step: Тип шага (обычный, самый первый, самый последний), по умолчанию `regular`
        ///   - orderID: Порядковый номер шага/этап онбординга, минимальный номер для обычного шага - `1`, для экстра-первого - `0`
        ///   - title: Заголовок тултипа
        ///   - message: Описание в тултипе
        ///   - maskPadding: Паддинг вокруг выделенного элемента
        ///   - hideNavigationTitle: Нужно ли прятать заголовок навбара. При выделении кнопок в навбаре заголовок нужно прятать. По умолчанию `false`
        ///   - isIgnored: Нужно ли игнорировать этот шаг онбординга. Используется, чтобы не показывать повторно
        ///   ранее просмотренные этапы онбординга при добавлении новых шагов
        init(
            id: String,
            step: Step = .regular,
            orderID: Int,
            title: String,
            message: String,
            maskPadding: CGFloat,
            hideNavigationTitle: Bool = false,
            isIgnored: Bool
        ) {
            self.id = id
            self.step = step
            self.orderID = orderID
            self.title = title
            self.message = message
            self.maskPadding = maskPadding
            self.hideNavigationTitle = hideNavigationTitle
            self.isIgnored = isIgnored
        }
        
        /// Инициализатор для тултипа с выделенным элементом на экране
        ///
        /// Тултип располагается над или под выделенным элементом
        /// - Parameters:
        ///   - id: Уникальный идентификатор шага онбординга, по умолчанию `UUID().uuidString`
        ///   - stepOrder: Порядковый номер шага онбординга. Для обычного первого шага должен быть равен `1`.
        ///   Каждый следующий шаг должен иметь порядковый номер на `1` выше предыдущего
        ///   - title: Заголовок тултипа
        ///   - message: Описание в тултипе
        ///   - maskPadding: Паддинг вокруг выделенного элемента, по умолчанию `0`
        ///   - hideNavigationTitle: Нужно ли прятать заголовок навбара. При выделении кнопок в навбаре заголовок нужно прятать. По умолчанию `false`
        ///   - isIgnored: Нужно ли игнорировать этот шаг онбординга, по умолчанию `false`. Используется, чтобы не показывать повторно
        ///   ранее просмотренные этапы онбординга при добавлении новых шагов
        public init(
            id: String = UUID().uuidString,
            stepOrder: Int,
            title: String,
            message: String,
            maskPadding: CGFloat = 0,
            hideNavigationTitle: Bool = false,
            isIgnored: Bool = false
        ) {
            self.init(
                id: id,
                orderID: stepOrder,
                title: title,
                message: message,
                maskPadding: maskPadding,
                hideNavigationTitle: hideNavigationTitle,
                isIgnored: isIgnored
            )
        }
        
        /// Инициализатор для дополнительного первого шага онбординга
        /// - Parameter extraFirst: Модель для шага онбординга
        init?(extraFirst: ExtraFirst?) {
            if let model = extraFirst {
                self.init(
                    id: model.id,
                    step: .extraFirst,
                    orderID: model.orderID,
                    title: model.title,
                    message: model.message,
                    maskPadding: 0,
                    isIgnored: model.isIgnored
                )
            } else {
                return nil
            }
        }
        
        /// Инициализатор для дополнительного последнего шага онбординга
        /// - Parameter extraLast: Модель для шага онбординга
        init?(extraLast: ExtraLast?) {
            if let model = extraLast {
                self.init(
                    id: model.id,
                    step: .extraLast,
                    orderID: model.orderID,
                    title: model.title,
                    message: model.message,
                    maskPadding: 0,
                    isIgnored: model.isIgnored
                )
            } else {
                return nil
            }
        }
    }
}

extension SUIOnboarding.ItemModel {
    enum Step {
        /// Обычный, с выделенным элементом UI на экране
        case regular
        /// Дополнительный первый, без выделенного UI-элемента на экране, только тултип
        case extraFirst
        /// Дополнительный последний, без выделенного UI-элемента на экране, только тултип
        case extraLast
        
        /// Является ли экстра-шагом без выделенного UI-элемента на экране
        var isExtra: Bool {
            switch self {
            case .extraFirst, .extraLast: true
            case .regular: false
            }
        }
    }
    
    /// Модель для экстра-шага перед первым элементом онбординга
    ///
    /// Порядковый номер такого шага всегда `0`
    public struct ExtraFirst {
        let id: String
        let orderID = 0
        let title: String
        let message: String
        let isIgnored: Bool
        
        /// Инициализатор
        ///
        /// Порядковый номер всегда `0`, т.к. это шаг должен идти самым первым в очереди
        /// - Parameters:
        ///   - id: Уникальный идентификатор шага онбординга, по умолчанию `UUID().uuidString`
        ///   - title: Заголовок тултипа
        ///   - message: Описание в тултипе
        ///   - isIgnored: Нужно ли игнорировать этот шаг онбординга, по умолчанию `false`. Используется, чтобы не показывать повторно
        ///   ранее просмотренные этапы онбординга при добавлении новых шагов
        public init(
            id: String = UUID().uuidString,
            title: String,
            message: String,
            isIgnored: Bool = false
        ) {
            self.id = id
            self.title = title
            self.message = message
            self.isIgnored = isIgnored
        }
    }
    
    /// Модель для экстра-шага после завершающего элемента онбординга
    public struct ExtraLast {
        let id: String
        public let orderID: Int
        public let title: String
        let message: String
        let isIgnored: Bool
        
        /// Инициализатор
        /// - Parameters:
        ///   - id: Уникальный идентификатор шага онбординга, по умолчанию `UUID().uuidString`
        ///   - orderID: Порядковый номер этого шага, должен быть выше предыдущего на `1`
        ///   - title: Заголовок тултипа
        ///   - message: Описание в тултипе
        ///   - isIgnored: Нужно ли игнорировать этот шаг онбординга, по умолчанию `false`. Используется, чтобы не показывать повторно
        ///   ранее просмотренные этапы онбординга при добавлении новых шагов
        public init(
            id: String = UUID().uuidString,
            orderID: Int,
            title: String,
            message: String,
            isIgnored: Bool = false
        ) {
            self.id = id
            self.orderID = orderID
            self.title = title
            self.message = message
            self.isIgnored = isIgnored
        }
    }
}
