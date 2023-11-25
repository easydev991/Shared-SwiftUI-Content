import SwiftUI

/// Экран "Профиль"
struct NVProfileScreen: View {
    /// Используется для возврата на предыдущий экран
    ///
    /// - Работает как в `NavigationLink`, так и в `sheet`/`fullscreenCover`
    /// - До iOS 15 используется `presentationMode`
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: NVAppViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Вернуться на главную") {
                dismiss()
            }
            Button("Выйти", role: .destructive) {
                viewModel.process(action: .performLogout)
            }
        }
        .buttonStyle(.borderedProminent)
        .navigationTitle("Профиль")
    }
}

#Preview {
    NavigationView {
        NVProfileScreen()
            .environmentObject(NVAppViewModel())
    }
}
