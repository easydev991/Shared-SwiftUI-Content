import SwiftUI

struct StrokeVsStrokeBorder: View {
    var body: some View {
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.red, lineWidth: 4)
                    .frame(height: 100)
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.blue, lineWidth: 4)
                    .frame(height: 100)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    StrokeVsStrokeBorder()
}
