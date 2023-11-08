import SwiftUI

struct EasyPagingView: View {
    var body: some View {
        _PagingView( // 1
            direction: .vertical, // 2
            views: [ // 3
                Rectangle().foregroundColor(.yellow),
                Rectangle().foregroundColor(.red),
                Rectangle().foregroundColor(.blue),
                Rectangle().foregroundColor(.green)
            ]
        )
        .ignoresSafeArea() // 4
    }
}

#Preview { EasyPagingView() }
