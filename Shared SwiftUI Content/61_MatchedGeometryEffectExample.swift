import SwiftUI

struct MatchedGeometryEffectExample: View {
    @State private var showCircle = false
    
    @Namespace private var defaultAnimation
    private let defaultAnimationId = "defaultAnimation"
    @Namespace private var animationTwo
    private let animationTwoId = "animationTwo"
    @Namespace private var animationThree
    private let animationThreeId = "animationThree"
    @Namespace private var animationFour
    private let animationFourId = "animationFour"
    
    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                noEffectOption // без matchedGeometryEffect
                defaultOption // matchedGeometryEffect без настроек
                customAnchorAndPropertiesOption // matchedGeometryEffect, настроено все кроме источника
                customOptionCircleIsSource // matchedGeometryEffect, где источник - круг
                customOptionRectangleIsSource // matchedGeometryEffect, где источник - прямоугольник
            }
            Button("Сменить фигуру") {
                withAnimation(.linear(duration: 0.5)) {
                    showCircle.toggle()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    /// Не использует `matchedGeometryEffect`
    @ViewBuilder
    private var noEffectOption: some View {
        if showCircle {
            greenCircle
        } else {
            blackRectangle
        }
    }
    
    /// Использует `matchedGeometryEffect`, параметры по умолчанию
    @ViewBuilder
    private var defaultOption: some View {
        if showCircle {
            greenCircle
                .matchedGeometryEffect(
                    id: defaultAnimationId,
                    in: defaultAnimation
                )
        } else {
            blackRectangle
                .matchedGeometryEffect(
                    id: defaultAnimationId,
                    in: defaultAnimation
                )
        }
    }
    
    /// Использует `matchedGeometryEffect`, настроено все кроме источника
    @ViewBuilder
    private var customAnchorAndPropertiesOption: some View {
        if showCircle {
            greenCircle
                .matchedGeometryEffect(
                    id: animationTwoId,
                    in: animationTwo,
                    properties: .position,
                    anchor: .trailing
                )
        } else {
            blackRectangle
                .matchedGeometryEffect(
                    id: animationTwoId,
                    in: animationTwo,
                    anchor: .leading
                )
        }
    }
    
    /// Использует `matchedGeometryEffect`, источник - круг, остальное по умолчанию
    @ViewBuilder
    private var customOptionCircleIsSource: some View {
        if showCircle {
            greenCircle
                .matchedGeometryEffect(
                    id: animationFourId,
                    in: animationFour
                )
        } else {
            blackRectangle
                .matchedGeometryEffect(
                    id: animationFourId,
                    in: animationFour,
                    isSource: false
                )
        }
    }
    
    /// Использует `matchedGeometryEffect`, источник - прямоугольник, остальное по умолчанию
    @ViewBuilder
    private var customOptionRectangleIsSource: some View {
        if showCircle {
            greenCircle
                .matchedGeometryEffect(
                    id: animationThreeId,
                    in: animationThree,
                    isSource: false
                )
        } else {
            blackRectangle
                .matchedGeometryEffect(
                    id: animationThreeId,
                    in: animationThree
                )
        }
    }
    
    private var greenCircle: some View {
        VStack(spacing: 0) {
            Circle()
                .fill(.green)
                .frame(width: 100, height: 100)
            spacerWithFrame
        }
    }
    
    private var blackRectangle: some View {
        VStack(spacing: 0) {
            spacerWithFrame
            Rectangle()
                .frame(width: 300, height: 50)
        }
    }
    
    private var spacerWithFrame: some View {
        Spacer().frame(height: 100)
    }
}

#Preview {
    MatchedGeometryEffectExample()
}
