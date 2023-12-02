import SwiftUI

/// Экран "Закладки"
struct NSBookmarksScreen: View {
    @EnvironmentObject private var viewModel: NSAppViewModel
    private let demoBookmarks: [Bookmark] = (1..<10).map {
        .init(title: "Закладка № \($0)")
    }
    
    var body: some View {
        List(demoBookmarks) { item in
            if item.isError {
                Button(item.title) {
                    viewModel.process(action: .showError(item.errorMessage))
                }
            } else {
                NavigationLink(destination: Text(item.title)) {
                    Text(item.title)
                }
            }
        }
        .navigationTitle("Закладки")
    }
}

private extension NSBookmarksScreen {
    struct Bookmark: Identifiable {
        let id = UUID()
        let title: String
        let isError = Bool.random()
        
        var errorMessage: String {
            "Не удалось открыть закладку с идентификатором \(id)"
        }
    }
}

#Preview {
    NavigationStack {
        NSBookmarksScreen()
            .environmentObject(NSAppViewModel())
    }
}
