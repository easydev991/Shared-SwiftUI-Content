import SwiftUI

/// Содержит инструменты для работы с онбордингом
public enum SUIOnboarding {
    /// Название плоскости координат для работы с маской выделенного элемента онбординга
    static let coordinateNamespace = "HighlightOverlayCoordinateSpace"
}

struct OnboardingExample: View {
    @State private var isReadyForOnboarding = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                isReadyForOnboarding = true
            } label: {
                Text("Начать (1)")
                    .font(.title2)
                    .padding(8)
                    .background(Color.green)
                    .clipShape(.capsule)
            }
            Button {} label: {
                Text("Кнопка №2")
                    .font(.title2)
                    .padding(8)
                    .background(Color.green)
                    .clipShape(.capsule)
            }
            .tooltipItem(
                .init(
                    stepOrder: 2,
                    title: "Кнопка №2",
                    message: "Вторая кнопка на экране с кастомным паддингом для маски, ничего не делает",
                    maskPadding: 40
                )
            )
            HStack {
                ForEach(3..<6) { id in
                    Text("Элемент \(id)")
                        .font(.title3)
                        .padding(4)
                        .background(Color.red)
                        .clipShape(.capsule)
                        .tooltipItem(
                            .init(
                                stepOrder: id,
                                title: "Элемент \(id)",
                                message: "Еще один элемент на экране, номер \(id)"
                            )
                        )
                }
            }
            Text("Большой элемент №6")
                .font(.title)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color.purple)
                .cornerRadius(12)
                .tooltipItem(
                    .init(
                        stepOrder: 6,
                        title: "Сиреневый раздел",
                        message: "Большой раздел сиреневого цвета, находится чуть ниже середины экрана"
                    )
                )
            Text("Элемент №7")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.cyan)
                .cornerRadius(12)
                .tooltipItem(
                    .init(
                        stepOrder: 7,
                        title: "Нижний раздел",
                        message: "Средний размер, находится в нижней части экрана"
                    )
                )
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isReadyForOnboarding = true
                } label: {
                    Image(systemName: "play")
                        .foregroundColor(.black)
                }
                .tooltipItem(
                    .init(
                        stepOrder: 1,
                        title: "Кнопка 1",
                        message: "Первая кнопка на экране, может запускать онбординг",
                        hideNavigationTitle: true
                    )
                )
            }
        }
        .withOnboardingOverlay(
            isReadyForOnboarding: isReadyForOnboarding,
            navigationTitle: "Заголовок экрана",
            extraFirstItem: .init(
                title: "Привет, Пользователь!",
                message: "В этом онбординге научим пользоваться приложением"
            ),
            extraLastItem: .init(
                orderID: 8,
                title: "Это финиш!",
                message: "Пользуйтесь приложением на здоровье"
            ),
            didAppear: { item in
                print("увидели шаг \(item.id)")
            },
            didTapClose: { item in
                print("закрыли на шаге \(item.id)")
            },
            didTapFinish: {
                print("Нажали на кнопку *завершить* и закрыли онбординг")
            }
        )
    }
}

#Preview { 
    NavigationView { OnboardingExample() }
}
