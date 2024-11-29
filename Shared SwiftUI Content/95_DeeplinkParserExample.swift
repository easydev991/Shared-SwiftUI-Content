import DeeplinkParser
import SwiftUI

struct DeeplinkParserExample: View {
    @State private var navigationDestination: NavigationDestination?
    private let simpleDeeplinkURL = URL(string: "easydev991://simple")!
    private let complexDeeplinkURL = URL(string: "easydev991://complex?id=991")!
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Экран, обрабатывающий диплинк")
                Button("Диплинк без параметра") {
                    UIApplication.shared.open(simpleDeeplinkURL)
                }
                Button("Диплинк с параметром") {
                    UIApplication.shared.open(complexDeeplinkURL)
                }
            }
            .background(
                NavigationLink(
                    destination: destinationView,
                    isActive: $navigationDestination.mappedToBool()
                )
            )
        }
        .onOpenURL { url in
            guard let path = DeeplinkParser(url: url).path else { return }
            // Показываем нужный экран в зависимости от `path`
            switch path {
            case .simple:
                navigationDestination = .screen1
            case let .complex(id):
                navigationDestination = .screen2(id)
            }
        }
    }
    
    @ViewBuilder
    private var destinationView: some View {
        if let navigationDestination {
            switch navigationDestination {
            case .screen1: Text("Экран для диплинка без параметра")
            case let .screen2(id): Text("Экран для диплинка с параметром: \(id)")
            }
        }
    }
}

extension DeeplinkParserExample {
    private enum NavigationDestination: Hashable {
        case screen1
        case screen2(String)
    }
}

#Preview {
    DeeplinkParserExample()
}
