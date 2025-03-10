import SwiftUI

@main
struct Shared_SwiftUI_ContentApp: App {
    var body: some Scene {
        WindowGroup {
            let items: [MapSnapshotExample.MapModel] = [5000, 2500, 1250, 600, 300].map {
                .init(latitude: 55.795396, longitude: 37.762597, locationDistance: $0)
            }
            return ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(zip(items.indices, items)), id: \.0) { _, model in
                        MapSnapshotExample(mapModel: model)
                    }
                }
                .padding()
            }
        }
    }
}
