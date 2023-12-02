import SwiftUI

/// Экран "Профиль"
struct NSProfileScreen: View {
    /// Используется для возврата на предыдущий экран
    ///
    /// - Работает как в `NavigationLink`, так и в `sheet`/`fullscreenCover`
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: NSAppViewModel
    
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
    NavigationStack {
        NVProfileScreen()
            .environmentObject(NSAppViewModel())
    }
}
