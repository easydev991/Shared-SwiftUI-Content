import SwiftUI

struct ViewThatFitsExample: View {
    let date: Date
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            horizontalView
            compactView
        }
        .padding(.horizontal, 20)
    }
    
    private var horizontalView: some View {
        HStack(spacing: 24) {
            leftButton
            dateView
            rightButton
            resetButton
        }
    }
    
    private var compactView: some View {
        VStack(spacing: 8) {
            dateView
            HStack {
                leftButton
                resetButton
                rightButton
            }
        }
    }
    
    private var dateView: some View {
        Text(date.formatted(date: .complete, time: .standard))
            .font(.title2)
    }
    
    private var leftButton: some View {
        Image(systemName: "arrowtriangle.left.fill")
            .font(.title)
    }
    
    private var rightButton: some View {
        Image(systemName: "arrowtriangle.right.fill")
            .font(.title)
    }
    
    private var resetButton: some View {
        Image(systemName: "clock.arrow.circlepath")
            .foregroundStyle(.white)
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.red)
            }
    }
}

#Preview {
    ViewThatFitsExample(date: .now)
}
