@preconcurrency import MapKit
import OSLog
import SwiftUI

struct MapSnapshotExample: View {
    let mapModel: MapModel
    /// Высота вьюхи по дизайну
    private let height: CGFloat = 153
    @State private var snapshotImage: UIImage?
    /// Габариты для создания снимка
    @State private var currentSize: CGSize?

    var body: some View {
        GeometryReader { geo in
            makeContentView(width: geo.size.width)
                .animation(.easeInOut, value: snapshotImage)
                .clipShape(.rect(cornerRadius: 8))
                .task(id: mapModel) {
                    await generateSnapshot(size: geo.size, force: true)
                }
                .task(id: geo.size) {
                    await generateSnapshot(size: geo.size)
                }
        }
        .frame(height: height)
    }
}

extension MapSnapshotExample {
    struct MapModel: Equatable {
        let latitude: Double
        let longitude: Double
        let locationDistance: CLLocationDistance
        
        init(
            latitude: Double,
            longitude: Double,
            locationDistance: CLLocationDistance = 1000
        ) {
            self.latitude = latitude
            self.longitude = longitude
            self.locationDistance = locationDistance
        }

        var coordinate: CLLocationCoordinate2D {
            .init(latitude: latitude, longitude: longitude)
        }

        var isComplete: Bool {
            latitude != 0 && longitude != 0
        }
    }
}

private extension MapSnapshotExample {
    func makeContentView(width: CGFloat) -> some View {
        ZStack {
            if let snapshotImage {
                Image(uiImage: snapshotImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .transition(.opacity.combined(with: .scale))
            } else {
                Image(.swiftDark)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .background(.black)
                    .clipShape(.rect(cornerRadius: 12))
                    .transition(.opacity.combined(with: .scale))
            }
        }
    }

    @MainActor
    func generateSnapshot(size: CGSize, force: Bool = false) async {
        guard mapModel.isComplete else { return }
        guard currentSize != size || force else { return }
        currentSize = size
        let options = MKMapSnapshotter.Options()
        options.region = .init(
            center: mapModel.coordinate,
            latitudinalMeters: mapModel.locationDistance,
            longitudinalMeters: mapModel.locationDistance
        )
        options.size = .init(width: size.width, height: size.height)
        options.pointOfInterestFilter = .excludingAll // для iOS 17 есть спец.настройка

        let snapshotter = MKMapSnapshotter(options: options)
        do {
            let snapshot = try await snapshotter.start()
            let image = await withCheckedContinuation { continuation in
                let result = UIGraphicsImageRenderer(size: options.size).image { _ in
                    snapshot.image.draw(at: .zero)
                    let point = snapshot.point(for: mapModel.coordinate)
                    let annotationView = MKMarkerAnnotationView(
                        annotation: nil,
                        reuseIdentifier: nil
                    )
                    annotationView.contentMode = .scaleAspectFit
                    annotationView.bounds = .init(x: 0, y: 0, width: 40, height: 40)
                    let viewBounds = annotationView.bounds
                    annotationView.drawHierarchy(
                        in: .init(
                            x: point.x - viewBounds.width / 2,
                            y: point.y - viewBounds.height,
                            width: viewBounds.width,
                            height: viewBounds.height
                        ),
                        afterScreenUpdates: true
                    )
                }
                continuation.resume(returning: result)
            }
            snapshotImage = image
        } catch {
            let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "MyApp", category: "MapSnapshotView")
            logger.error("Ошибка при создании снапшота карты: \(error, privacy: .public)")
            snapshotImage = nil
        }
    }
}

extension [MapSnapshotExample.MapModel] {
    static let demoItems: Self = [
        .init(latitude: 55.795396, longitude: 37.762597),
        .init(latitude: 55.687001, longitude: 37.504467),
        .init(latitude: 55.624178, longitude: 37.69965),
        .init(latitude: 55.774852, longitude: 37.727476),
        .init(latitude: 55.762228, longitude: 37.701406),
        .init(latitude: 55.87913, longitude: 37.65226),
        .init(latitude: 59.838011, longitude: 30.313087),
        .init(latitude: 59.847391, longitude: 30.351483)
    ]
}

#Preview("Разные локации, один масштаб") {
    let items = [MapSnapshotExample.MapModel].demoItems
    return ScrollView {
        LazyVStack(spacing: 12) {
            ForEach(Array(zip(items.indices, items)), id: \.0) { _, model in
                MapSnapshotExample(
                    mapModel: .init(
                        latitude: model.latitude,
                        longitude: model.longitude
                    )
                )
            }
        }
        .padding()
    }
}

#Preview("Одна локация, разный масштаб") {
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
