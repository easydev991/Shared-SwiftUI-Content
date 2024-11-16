import UIKit
import SwiftUI
import AVKit

private let demoURL = URL(string: "https://leonardo.osnova.io/4afddc22-8d03-54d3-882f-5aa1fed0765c/-/format/mp4")!

struct DefaultVideoPlayerExample: View {
    @State private var player = AVPlayer(url: demoURL)
    
    var body: some View {
        VideoPlayer(player: player)
            .disabled(true) // выключает элементы управления плеером
            .ignoresSafeArea()
            .onAppear {
                player.isMuted = true // выключает звук у видео
                player.play() // запускает видео при появлении экрана
            }
    }
}

struct AVPlayerVCRepresentable: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        // выключает элементы управления плеером
        controller.showsPlaybackControls = false
        // Аналогично настройке картинок:
        // .resizeAspectFill = .scaleToFill
        // .resizeAspect = .scaleToFit
        controller.videoGravity = .resizeAspect
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

struct AVPlayerSwiftUIDemo: View {
    @State private var player = AVPlayer(url: demoURL)
    
    var body: some View {
        AVPlayerVCRepresentable(player: player)
            .ignoresSafeArea()
            .onAppear {
                player.isMuted = true // выключает звук у видео
                player.play() // запускает видео при появлении экрана
            }
    }
}

#Preview("Дефолтный плеер") {
    DefaultVideoPlayerExample()
}

#Preview("AVPlayerVCRepresentable") {
    AVPlayerSwiftUIDemo()
}
