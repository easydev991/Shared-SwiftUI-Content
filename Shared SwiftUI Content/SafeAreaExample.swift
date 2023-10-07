import SwiftUI

struct SafeAreaExample: View {
    var body: some View {
        VStack {
            GeometryReader { geo in // 1
                Color.blue
                    .frame(height: geo.size.height/2) // 2
                    .ignoresSafeArea() // 3
                    .overlay {
                        VStack {
                            Capsule()
                                .foregroundColor(.green)
                                .frame(width: 80, height: 40)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding([.top, .leading])
                            Spacer()
                            Circle()
                                .foregroundColor(.yellow)
                                .padding(.bottom, geo.safeAreaInsets.top) // 4
                        }
                    }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    SafeAreaExample()
}
