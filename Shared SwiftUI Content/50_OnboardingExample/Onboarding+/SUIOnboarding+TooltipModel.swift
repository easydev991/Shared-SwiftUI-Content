import Foundation

extension SUIOnboarding {
    /// Модель тултипа для шага онбординга
    struct TooltipModel {
        /// Является ли этот шаг экстра-шагом
        let isExtra: Bool
        /// Идет ли этот шаг следующим после экстра-шага
        let isAfterExtra: Bool
        let isFirst: Bool
        let currentID: Int
        let lastID: Int
        let shapeModel: ShapeModel
        let title: String
        let message: String
        /// Нужно ли показывать кнопку с крестиком для закрытия онбординга
        let showCloseButton: Bool
        let actions: Actions
        
        private var isExtraFirst: Bool {
            isExtra && isFirst
        }
        
        private var isOnlyOne: Bool {
            currentID == 1 && currentID == lastID
        }
        
        /// Который это элемент по счету из общего числа, например, "1 из 6"
        var countDescription: String {
            isExtraFirst || isOnlyOne
            ? ""
            : "\(currentID) из \(lastID)"
        }
        
        var buttons: Buttons {
            let begin = ButtonModel(kind: .begin, title: "Поехали") { actions.goTo(currentID + 1) }
            let back = ButtonModel(kind: .back, title: "Назад") { actions.goTo(currentID - 1) }
            let forward = ButtonModel(kind: .forward, title: "Вперёд") { actions.goTo(currentID + 1) }
            let finish = ButtonModel(kind: .forward, title: "Завершить", action: actions.finish)
            let isLast = currentID == lastID
            guard !isOnlyOne else { return .finish(finish) }
            if isExtraFirst { return .begin(begin) }
            if (!isExtra && isFirst) || isAfterExtra { return .forward(forward) }
            if !isFirst && !isLast {
                return .backAndForward(back: back, forward: forward)
            } else {
                return .backAndFinish(back: back, finish: finish)
            }
        }
    }
}

extension SUIOnboarding.TooltipModel {
    /// Действия для управления онбордингом
    struct Actions {
        /// Перейти к элементу с указанным `id`
        let goTo: (_ id: Int) -> Void
        /// Закрыть онбординг по кнопке с крестиком
        let close: () -> Void
        /// Завершить онбординг по кнопке "Завершить"
        let finish: () -> Void
    }
    
    /// Модель формы тултипа
    struct ShapeModel {
        let cornerRadius: CGFloat
        let arrowModel: ArrowModel?
        let extraHorizontalPadding: CGFloat
        
        /// Инициализатор
        /// - Parameters:
        ///   - cornerRadius: Радиус углов формы, по умолчанию `12`
        ///   - arrowModel: Модель стрелки. Eсли передать `nil`, стрелки не будет
        ///   - extraHorizontalPadding: Дополнительный горизонтальный паддинг, влияет на положение стрелки в форме,
        /// должен быть равен горизонтальным паддингам тултипа, по умолчанию `20`
        init(
            cornerRadius: CGFloat = 12,
            arrowModel: ArrowModel?,
            extraHorizontalPadding: CGFloat = 20
        ) {
            self.cornerRadius = cornerRadius
            self.arrowModel = arrowModel
            self.extraHorizontalPadding = extraHorizontalPadding
        }
        
        struct ArrowModel {
            enum Direction: Sendable { case up, down }
            let direction: Direction
            let xOffset: CGFloat
            let height: CGFloat
            let width: CGFloat
            
            /// Инициализатор
            /// - Parameters:
            ///   - direction: Направление стрелки (вверх или вниз)
            ///   - width: Ширина стрелки, по умолчанию 13
            ///   - height: Высота стрелки, по умолчанию 8
            ///   - xOffset: Положение центра стрелки по оси `X`
            init(
                direction: Direction,
                width: CGFloat = 13,
                height: CGFloat = 8,
                xOffset: CGFloat
            ) {
                self.direction = direction
                self.xOffset = xOffset
                self.height = height
                self.width = width
            }
        }
    }
    
    /// Какие кнопки есть в нижней части тултипа
    enum Buttons {
        /// Только кнопка "Начать"
        case begin(ButtonModel)
        /// Только кнопка "Вперёд"
        case forward(ButtonModel)
        /// Кнопки "Назад" и "Вперёд"
        case backAndForward(back: ButtonModel, forward: ButtonModel)
        /// Кнопки "Назад" и "Завершить"
        case backAndFinish(back: ButtonModel, finish: ButtonModel)
        /// Только кнопка "Завершить"
        case finish(ButtonModel)
    }
    
    /// Модель кнопки в нижней части тултипа
    struct ButtonModel {
        enum Kind { case begin, back, forward }
        let kind: Kind
        let title: String
        let action: () -> Void
    }
}
