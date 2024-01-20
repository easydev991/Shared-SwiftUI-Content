import SwiftUI

extension SUIOnboarding {
    /// Модификатор для отображения этапов онбординга поверх основного контента экрана
    struct OverlayViewModifier<MaskView: View>: ViewModifier {
        @Environment(\.scenePhase) private var scenePhase
        /// Словарь со всеми элементами экрана для онбординга и их фреймами
        @State private var allItems = MaskFramePreferenceKey.Value()
        /// Элемент онбординга для текущего шага
        @State private var currentItem: ItemModel?
        /// Фрейм элемента онбординга для текущего шага
        @State private var currentItemMaskFrame: CGRect = .zero
        /// Высота тултипа, используется для вычисления его положения по оси `Y`
        @State private var tooltipViewHeight: CGFloat = 0
        /// Нужно ли прятать заголовок в навбаре
        @State private var hideNavigationTitle = false
        @State private var showOnboarding = false
        let isReadyForOnboarding: Bool
        let navigationTitle: String
        let extraFirstItem: ItemModel?
        let extraLastItem: ItemModel?
        let maskView: MaskView
        let didAppear: (ItemModel) -> Void
        let didTapClose: (ItemModel) -> Void
        let didTapFinish: () -> Void
        
        func body(content: Content) -> some View {
            ZStack {
                content
                    .navigationTitle(hideNavigationTitle ? "" : navigationTitle)
                    .onPreferenceChange(MaskFramePreferenceKey.self) { newItems in
                        updateAllItems(newItems: newItems)
                    }
                    .onChange(of: allItems) { newItems in
                        updateCurrentItemFrame(items: newItems)
                    }
                    .onChange(of: currentItem) { newItem in
                        if let newItem { didAppear(newItem) }
                        updateCurrentItemFrame(items: allItems, newItem: newItem)
                    }
                    .onChange(of: showOnboarding, perform: setupFirstItem)
                
                ZStack {
                    if let item = currentItem {
                        backgroundView
                        if currentItemMaskFrame != .zero {
                            makeMaskedItemView(item)
                        }
                        makeTooltipView(item)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: currentItemMaskFrame)
                .coordinateSpace(name: coordinateNamespace)
                .compositingGroup()
                .opacity(currentItem != nil ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: currentItem != nil)
                .ignoresSafeArea()
            }
            .onAppear {
                showOnboardingIfNeeded(isReady: isReadyForOnboarding)
            }
            .onChange(of: isReadyForOnboarding) { newValue in
                showOnboardingIfNeeded(isReady: newValue)
            }
            .onChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .active: showOnboardingIfNeeded(isReady: isReadyForOnboarding)
                case .background: showOnboarding = false
                default: break
                }
            }
        }
        
        /// Порядковые номера первого и последнего элементов онбординга
        private var ids: (first: Int, last: Int) {
            let totalCount = allItems.count
            let allKeys = allItems.map(\.key)
            let hasExtraFirst = allKeys.contains(where: \.isFirstExtra)
            let firstID = hasExtraFirst ? 0 : 1
            let lastID = hasExtraFirst ? totalCount - 1 : totalCount
            return (firstID, lastID)
        }
        
        /// Слегка размытый темный фон онбординга, не дает нажимать никуда кроме тултипа
        private var backgroundView: some View {
            ZStack {
                UIVisialEffectViewRepresentable(
                    effect: UIBlurEffect(style: .dark),
                    intensity: 0.085
                )
                Color.black.opacity(0.75)
            }
        }
        
        /// Делает вьюшку-маску для выделения текущего элемента онбординга
        private func makeMaskedItemView(_ item: ItemModel) -> some View {
            let pinnedViewSize = CGSize(
                width: currentItemMaskFrame.size.width + item.maskPadding,
                height: currentItemMaskFrame.size.height + item.maskPadding
            )
            return maskView
                .frame(width: pinnedViewSize.width, height: pinnedViewSize.height)
                .position(x: currentItemMaskFrame.midX, y: currentItemMaskFrame.midY)
                .blendMode(.destinationOut)
                .allowsHitTesting(false)
        }
        
        /// Делает вьюшку с тултипом для выбранного элемента онбординга
        private func makeTooltipView(_ item: ItemModel) -> some View {
            let helperPosition = makeTooltipPosition(for: item)
            let isExtra = item.step.isExtra
            let isLastItem = isExtra ? item.step == .extraLast : item.orderID == ids.last
            let model = TooltipModel(
                isExtra: isExtra,
                isAfterExtra: extraFirstItem != nil && item.orderID == 1,
                isFirst: isExtra ? item.step == .extraFirst : item.orderID == ids.first,
                currentID: item.orderID,
                lastID: ids.last,
                shapeModel: .init(
                    arrowModel: isExtra || item.hideNavigationTitle
                    ? nil
                    : .init(direction: helperPosition.arrowDirection, xOffset: currentItemMaskFrame.midX)
                ),
                title: item.title,
                message: item.message,
                showCloseButton: !item.hideNavigationTitle && !isLastItem,
                actions: .init(
                    goTo: { id in
                        currentItem = allItems.keys.first(where: { $0.orderID == id })
                    },
                    close: {
                        if let currentItem { didTapClose(currentItem) }
                        closeOnboarding()
                    },
                    finish: {
                        didTapFinish()
                        closeOnboarding()
                    }
                )
            )
            let tooltipView = TooltipView(model: model)
            return ZStack {
                if isExtra {
                    tooltipView
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 32)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    tooltipView
                        .transition(.scale.combined(with: .opacity))
                        .readSize { tooltipViewHeight = $0.height }
                        .position(x: helperPosition.x, y: helperPosition.y)
                }
            }
            .animation(.easeInOut, value: item.step.isExtra)
        }
        
        /// Определяет позицию и направление стрелки для тултипа
        /// - Parameter item: Модель элемента экрана для онбординга
        /// - Returns: Положение по осям `X` / `Y` и направление стрелки для тултипа
        private func makeTooltipPosition(for item: ItemModel) -> (
            x: CGFloat,
            y: CGFloat,
            arrowDirection: TooltipModel.ShapeModel.ArrowModel.Direction
        ) {
            /// По оси X центр всегда совпадает с центром экрана
            let centerX = UIScreen.main.bounds.width / 2
            /// Центр экрана, относительно которого делаем расчеты
            let centerY = UIScreen.main.bounds.height / 2
            /// Разница между центром экрана и самой верхней точкой выделенной вьюшки
            let fromMinYToCenter = abs(centerY - currentItemMaskFrame.minY)
            /// Разница между центром экрана и самой нижней точкой выделенной вьюшки
            let fromMaxYToCenter = abs(centerY - currentItemMaskFrame.maxY)
            /// `true` - выделенная вьюшка находится в верхней части экрана, `false` - в нижней
            let isMainlyOnTop = fromMinYToCenter > fromMaxYToCenter
            /// "Лишняя" высота, которую нужно учитывать при расположении тултипа
            let extraHeight = tooltipViewHeight / 2
            /// Расстояние от выделенной вьюшки до тултипа по дизайну
            let extraPadding: CGFloat = item.hideNavigationTitle ? 16 : 8
            /// Дополнительный вертикальный паддинг для маски
            let verticalMaskPadding = item.maskPadding / 2
            let y = isMainlyOnTop
            ? currentItemMaskFrame.maxY + verticalMaskPadding + extraHeight + extraPadding
            : currentItemMaskFrame.minY - verticalMaskPadding - extraHeight - extraPadding
            return (centerX, y, isMainlyOnTop ? .up : .down)
        }
        
        /// Обновляет `allItems`
        /// - Parameter newItems: Новый словарь, где ключи - модели для шагов онбординга, а значения - фреймы для их UI-элементов
        private func updateAllItems(newItems: MaskFramePreferenceKey.Value) {
            /// Словарь без игнорируемых элементов
            let filteredDict = newItems.filter { !$0.key.isIgnored }
            guard !filteredDict.isEmpty else { return }
            let filteredDictCount = filteredDict.count
            let sortedFilteredDict = filteredDict.keys.sorted(by: { $0.orderID < $1.orderID })
            let hasExtraFirst = filteredDict.contains(where: \.key.isFirstExtra)
            let lastID = hasExtraFirst ? filteredDictCount - 1 : filteredDictCount
            /// Список порядковых номеров шагов онбординга по возрастанию
            let ordersArray = Array(1...lastID)
            /// Модели шагов онбординга с обновленным свойством `orderID`
            let updatedKeys: [ItemModel] = sortedFilteredDict.enumerated().map { index, value in
                ItemModel(
                    id: value.id,
                    orderID: ordersArray[index],
                    title: value.title,
                    message: value.message,
                    maskPadding: value.maskPadding,
                    hideNavigationTitle: value.hideNavigationTitle,
                    isIgnored: false
                )
            }
            /// Временный словарь, где ключ - `id` из модели шага онбординга
            let tempDict = filteredDict.reduce(into: [String: CGRect]()) { partialResult, dictElement in
                partialResult[dictElement.key.id] = dictElement.value
            }
            var finalDict = updatedKeys.reduce(into: MaskFramePreferenceKey.Value()) { partialResult, model in
                partialResult[model] = tempDict[model.id]
            }
            if let extraFirstItem, !extraFirstItem.isIgnored {
                finalDict[extraFirstItem] = .zero
            }
            if let extraLastItem, !extraLastItem.isIgnored, let updatedOrderIDItem = ItemModel(
                extraLast: .init(
                    orderID: lastID + 1,
                    title: extraLastItem.title,
                    message: extraLastItem.message
                )
            ) {
                finalDict[updatedOrderIDItem] = .zero
            }
            allItems = finalDict
        }
        
        /// Обновляет фрейм текущего элемента онбординга
        /// - Parameters:
        ///   - items: Все элементы онбординга с фреймами
        ///   - newItem: Текущий элемент онбординга
        private func updateCurrentItemFrame(
            items: MaskFramePreferenceKey.Value,
            newItem: ItemModel? = nil
        ) {
            let current = currentItem ?? newItem
            if let current,
               let storedItemKey = items.keys.first(where: { $0.id == current.id }),
               let storedFrame = items[storedItemKey] {
                currentItemMaskFrame = storedFrame
                hideNavigationTitle = current.hideNavigationTitle
            } else {
                currentItemMaskFrame = .zero
                hideNavigationTitle = false
            }
        }
        
        /// Настраивает первый элемент онбординга при изменении свойства `showOnboarding`
        private func setupFirstItem(_ showOnboarding: Bool) {
            if showOnboarding, !allItems.isEmpty, currentItem == nil {
                if let extraFirstItem, !extraFirstItem.isIgnored {
                    currentItem = extraFirstItem
                } else {
                    currentItem = allItems.keys.first(where: { $0.orderID == ids.first })
                }
            } else {
                currentItem = nil
            }
        }
        
        private func showOnboardingIfNeeded(isReady: Bool) {
            guard !showOnboarding, isReady else { return }
            Task {
                // Ждем 0.5 сек, чтобы корректно отобразить блюр
                try? await Task.sleep(nanoseconds: 500_000_000)
                showOnboarding = true
            }
        }
        
        private func closeOnboarding() {
            currentItem = nil
            showOnboarding = false
        }
    }
}

extension View {
    /// Добавляет оверлей для онбординга
    ///
    /// - Предварительно необходимо настроить экран - добавить модификатор `.tooltipItem` на каждый элемент онбординга на экране
    /// - Дополнительные элементы (`extraFirstItem`/`extraLastItem`) всегда располагаются в нижней части экрана
    ///
    /// - Parameters:
    ///   - isReadyForOnboarding: Условие для запуска онбординга. Например, успешно загружены все данные на экране
    ///   - navigationTitle: Заголовок в навбаре. Нужно настраивать именно тут, если в онбординге есть элементы навбара
    ///   - extraFirstItem: Дополнительный первый шаг онбординга (например, приветствие) без выделенного элемента
    ///   - extraLastItem: Дополнительный последний шаг онбординга без выделенного элемента
    ///   - maskView: Вюшка для выделения элемента онбординга, по умолчанию `RoundedRectangle(cornerRadius: 12, style: .continuous)`
    ///   - didAppear: Выполняется при появлении на экране шага онбординга и возвращает этот шаг
    ///   - didTapClose: Выполняется при закрытии онбординга пользователем по нажатию на кнопку с крестиком и возвращает текущий шаг онбординга
    ///   - didTapFinish: Выполняется при завершении онбординга пользователем по нажатию на кнопку "Готово"
    /// - Returns: Экран с возможностью проведения онбординга
    public func withOnboardingOverlay(
        isReadyForOnboarding: Bool,
        navigationTitle: String = "",
        extraFirstItem: SUIOnboarding.ItemModel.ExtraFirst? = nil,
        extraLastItem: SUIOnboarding.ItemModel.ExtraLast? = nil,
        maskView: some View = RoundedRectangle(cornerRadius: 12, style: .continuous),
        didAppear: @escaping (SUIOnboarding.ItemModel) -> Void = { _ in },
        didTapClose: @escaping (SUIOnboarding.ItemModel) -> Void = { _ in },
        didTapFinish: @escaping () -> Void = {}
    ) -> some View {
        modifier(
            SUIOnboarding.OverlayViewModifier(
                isReadyForOnboarding: isReadyForOnboarding,
                navigationTitle: navigationTitle,
                extraFirstItem: .init(extraFirst: extraFirstItem),
                extraLastItem: .init(extraLast: extraLastItem),
                maskView: maskView,
                didAppear: didAppear,
                didTapClose: didTapClose,
                didTapFinish: didTapFinish
            )
        )
    }
}
