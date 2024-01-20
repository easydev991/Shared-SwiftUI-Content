import SwiftUI

extension SUIOnboarding {
    /// Форма для тултипа со стрелкой, указывающей на выделенный UI-элемент онбординга
    struct TooltipShape: Shape {
        let cornerRadius: CGFloat
        let arrowModel: TooltipModel.ShapeModel.ArrowModel
        
        func path(in rect: CGRect) -> Path {
            let maxBoundedCornerRadius = min(
                min(cornerRadius, rect.width / 2),
                rect.height / 2
            )
            /// Используется во избежание конфликтных ситуаций с радиусом,
            /// чтобы `shape` не ломался из-за слишком большого радиуса углов
            let minBoundedCornerRadius = max(maxBoundedCornerRadius, 0.0)
            /// Магическое число, необходимо для выравнивания стрелки по центру
            let extraXOffset: CGFloat = 12
            switch arrowModel.direction {
            case .up:
                return makePathForArrowUP(
                    in: rect,
                    cornerRadius: minBoundedCornerRadius,
                    arrowXOffset: arrowModel.xOffset - extraXOffset,
                    arrowWidth: arrowModel.width,
                    arrowHeight: arrowModel.height
                )
            case .down:
                return makePathForArrowDown(
                    in: rect,
                    cornerRadius: minBoundedCornerRadius,
                    arrowXOffset: arrowModel.xOffset - extraXOffset,
                    arrowWidth: arrowModel.width,
                    arrowHeight: arrowModel.height
                )
            }
        }
        
        private func makePathForArrowUP(
            in rect: CGRect,
            cornerRadius: CGFloat,
            arrowXOffset: CGFloat,
            arrowWidth: CGFloat,
            arrowHeight: CGFloat
        ) -> Path {
            Path { path in
                path.move(to: .init(x: rect.minX + cornerRadius, y: rect.minY + arrowHeight))
                path.addLine(to: .init(x: arrowXOffset - arrowWidth, y: rect.minY + arrowHeight))
                path.addLine(to: .init(x: arrowXOffset - arrowWidth / 2, y: rect.minY))
                path.addLine(to: .init(x: arrowXOffset, y: rect.minY + arrowHeight))
                path.addLine(to: .init(x: rect.maxX - cornerRadius, y: rect.minY + arrowHeight))
                path.addArc(
                    tangent1End: .init(x: rect.maxX, y: rect.minY + arrowHeight),
                    tangent2End: .init(x: rect.maxX, y: rect.minY + arrowHeight + cornerRadius),
                    radius: cornerRadius
                )
                path.addLine(to: .init(x: rect.maxX, y: rect.maxY - cornerRadius))
                path.addArc(
                    tangent1End: .init(x: rect.maxX, y: rect.maxY),
                    tangent2End: .init(x: rect.maxX - cornerRadius, y: rect.maxY),
                    radius: cornerRadius
                )
                path.addLine(to: .init(x: rect.minX + cornerRadius, y: rect.maxY))
                path.addArc(
                    tangent1End: .init(x: rect.minX, y: rect.maxY),
                    tangent2End: .init(x: rect.minX, y: rect.maxY - cornerRadius),
                    radius: cornerRadius
                )
                path.addLine(to: .init(x: rect.minX, y: rect.minY + arrowHeight + cornerRadius))
                path.addArc(
                    tangent1End: .init(x: rect.minX, y: rect.minY + arrowHeight),
                    tangent2End: .init(x: rect.minX + cornerRadius, y: rect.minY + arrowHeight),
                    radius: cornerRadius
                )
                path.closeSubpath()
            }
        }
        
        private func makePathForArrowDown(
            in rect: CGRect,
            cornerRadius: CGFloat,
            arrowXOffset: CGFloat,
            arrowWidth: CGFloat,
            arrowHeight: CGFloat
        ) -> Path {
            Path { path in
                path.move(to: .init(x: rect.minX + cornerRadius, y: rect.minY))
                path.addLine(to: .init(x: rect.maxX - cornerRadius, y: rect.minY))
                path.addArc(
                    tangent1End: .init(x: rect.maxX, y: rect.minY),
                    tangent2End: .init(x: rect.maxX, y: rect.minY + cornerRadius),
                    radius: cornerRadius
                )
                path.addLine(to: .init(x: rect.maxX, y: rect.maxY - arrowHeight - cornerRadius))
                path.addArc(
                    tangent1End: .init(x: rect.maxX, y: rect.maxY - arrowHeight),
                    tangent2End: .init(x: rect.maxX - cornerRadius, y: rect.maxY - arrowHeight),
                    radius: cornerRadius
                )
                path.addLine(to: .init(x: arrowXOffset, y: rect.maxY - arrowHeight))
                path.addLine(to: .init(x: arrowXOffset - arrowWidth / 2, y: rect.maxY))
                path.addLine(to: .init(x: arrowXOffset - arrowWidth, y: rect.maxY - arrowHeight))
                path.addLine(to: .init(x: rect.minX + cornerRadius, y: rect.maxY - arrowHeight))
                path.addArc(
                    tangent1End: .init(x: rect.minX, y: rect.maxY - arrowHeight),
                    tangent2End: .init(x: rect.minX, y: rect.maxY - arrowHeight - cornerRadius),
                    radius: cornerRadius
                )
                path.addLine(to: .init(x: rect.minX, y: rect.minY + cornerRadius))
                path.addArc(
                    tangent1End: .init(x: rect.minX, y: rect.minY),
                    tangent2End: .init(x: rect.minX + cornerRadius, y: rect.minY),
                    radius: cornerRadius
                )
                path.closeSubpath()
            }
        }
    }
}
