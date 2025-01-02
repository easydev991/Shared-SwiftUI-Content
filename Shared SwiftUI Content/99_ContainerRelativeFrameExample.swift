import SwiftUI

@available(iOS 16.4, *)
struct ContainerRelativeFrameExample: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                if #available(iOS 17.0, *) {
                    Spacer().containerRelativeFrame([.vertical])
                }
                mainView
            }
        }
        .scrollBounceBehavior(.basedOnSize)
    }
    
    private var mainView: some View {
        VStack(spacing: 0) {
            ForEach(0..<10, id: \.self) { i in
                Text("# \(i)")
            }
            .frame(width: 100)
            .padding(.vertical)
        }
        .background(.green.opacity(0.5))
    }
}

@available(iOS 16.4, *)
#Preview {
    ContainerRelativeFrameExample()
}
