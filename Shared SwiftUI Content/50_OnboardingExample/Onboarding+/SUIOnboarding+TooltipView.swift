import SwiftUI

extension SUIOnboarding {
    struct TooltipView: View {
        let model: SUIOnboarding.TooltipModel
        
        private var arrowModel: SUIOnboarding.TooltipModel.ShapeModel.ArrowModel? {
            model.shapeModel.arrowModel
        }
        
        var body: some View {
            Group {
                if let arrowModel {
                    contentView
                        .clipShape(
                            SUIOnboarding.TooltipShape(
                                cornerRadius: model.shapeModel.cornerRadius,
                                arrowModel: arrowModel
                            )
                        )
                } else {
                    contentView
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: model.shapeModel.cornerRadius,
                                style: .continuous
                            )
                        )
                }
            }
            .padding(.horizontal, 20)
        }
        
        private var contentView: some View {
            VStack(alignment: .leading, spacing: 18) {
                titleSubtitleView
                buttonsView
                    .foregroundColor(.black)
                    .overlay(countTextView)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, extraTopPadding)
            .overlay(closeButtonIfNeeded, alignment: .topTrailing)
            .padding(.bottom, extraBottomPadding)
            .background(Color.orange)
        }
        
        private var extraTopPadding: CGFloat {
            if let arrowModel {
                arrowModel.direction == .up ? 28 : 20
            } else {
                20
            }
        }
        
        private var extraBottomPadding: CGFloat {
            if let arrowModel {
                arrowModel.direction == .up ? 20 : 28
            } else {
                20
            }
        }
        
        private var titleSubtitleView: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.title).font(.headline)
                Text(model.message).lineLimit(4)
            }
        }
        
        @ViewBuilder
        private var countTextView: some View {
            if !model.countDescription.isEmpty {
                Text(model.countDescription)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        
        @ViewBuilder
        private var buttonsView: some View {
            switch model.buttons {
            case let .begin(buttonModel):
                Button(buttonModel.title, action: buttonModel.action)
            case let .forward(buttonModel), let .finish(buttonModel):
                HStack {
                    Spacer()
                    Button(buttonModel.title, action: buttonModel.action)
                }
            case let .backAndForward(first, second), let .backAndFinish(first, second):
                HStack {
                    Button(first.title, action: first.action)
                    Spacer()
                    Button(second.title, action: second.action)
                }
            }
        }
        
        private var closeButtonTopPadding: CGFloat {
            if let arrowModel {
                arrowModel.direction == .up ? 17 : 9
            } else {
                9
            }
        }
        
        @ViewBuilder
        private var closeButtonIfNeeded: some View {
            if model.showCloseButton {
                Button(action: model.actions.close) {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                }
                .padding(.trailing, 9)
                .padding(.top, closeButtonTopPadding)
            }
        }
    }
}

#if DEBUG
#Preview("Первый, extra") {
    SUIOnboarding.TooltipView(
        model: .init(
            isExtra: true,
            isAfterExtra: false,
            isFirst: true,
            currentID: 0,
            lastID: 3,
            shapeModel: .init(arrowModel: nil),
            title: "Привет, Пользователь!",
            message: "В этом онбординге научим пользоваться приложением",
            showCloseButton: true,
            actions: .init(goTo: { _ in }, close: {}, finish: {})
        )
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

#Preview("Первый, regular") {
    SUIOnboarding.TooltipView(
        model: .init(
            isExtra: false,
            isAfterExtra: false,
            isFirst: true,
            currentID: 1,
            lastID: 3,
            shapeModel: .init(arrowModel: .init(direction: .up, xOffset: 80)),
            title: "Фича 1",
            message: "Это супер-важный функционал, который обязательно поможет вам решить любые задачи",
            showCloseButton: true,
            actions: .init(goTo: { _ in }, close: {}, finish: {})
        )
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

#Preview("Единственный, regular") {
    SUIOnboarding.TooltipView(
        model: .init(
            isExtra: false,
            isAfterExtra: false,
            isFirst: true,
            currentID: 1,
            lastID: 1,
            shapeModel: .init(arrowModel: .init(direction: .up, xOffset: 100)),
            title: "Вот такая фича",
            message: "Это супер-важный функционал, который обязательно поможет вам решить любые задачи",
            showCloseButton: false,
            actions: .init(goTo: { _ in }, close: {}, finish: {})
        )
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

#Preview("Второй, regular") {
    SUIOnboarding.TooltipView(
        model: .init(
            isExtra: false,
            isAfterExtra: false,
            isFirst: false,
            currentID: 2,
            lastID: 3,
            shapeModel: .init(arrowModel: .init(direction: .down, xOffset: 160)),
            title: "Фича 2",
            message: "Это супер-важный функционал, который обязательно поможет вам решить любые задачи",
            showCloseButton: true,
            actions: .init(goTo: { _ in }, close: {}, finish: {})
        )
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

#Preview("Второй после extra") {
    SUIOnboarding.TooltipView(
        model: .init(
            isExtra: false,
            isAfterExtra: true,
            isFirst: true,
            currentID: 1,
            lastID: 3,
            shapeModel: .init(arrowModel: .init(direction: .down, xOffset: 160)),
            title: "Фича 2",
            message: "Это супер-важный функционал, который обязательно поможет вам решить любые задачи",
            showCloseButton: true,
            actions: .init(goTo: { _ in }, close: {}, finish: {})
        )
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

#Preview("Последний, regular") {
    SUIOnboarding.TooltipView(
        model: .init(
            isExtra: false,
            isAfterExtra: false,
            isFirst: false,
            currentID: 3,
            lastID: 3,
            shapeModel: .init(arrowModel: .init(direction: .up, xOffset: 240)),
            title: "Фича 3",
            message: "Это супер-важный функционал, который обязательно поможет вам решить любые задачи",
            showCloseButton: false,
            actions: .init(goTo: { _ in }, close: {}, finish: {})
        )
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

#Preview("Последний, extra") {
    SUIOnboarding.TooltipView(
        model: .init(
            isExtra: true,
            isAfterExtra: false,
            isFirst: false,
            currentID: 3,
            lastID: 3,
            shapeModel: .init(arrowModel: nil),
            title: "Это финиш!",
            message: "Пользуйтесь приложением на здоровье",
            showCloseButton: false,
            actions: .init(goTo: { _ in }, close: {}, finish: {})
        )
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
#endif
