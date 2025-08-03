import SwiftUI

struct DrawingGroupAnimationExample: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 12) {
            headerView
            if isExpanded {
                demoItemsView
            }
        }
    }
}

private extension DrawingGroupAnimationExample {
    var headerView: some View {
        HStack(spacing: 8) {
            Text("Заголовок секции")
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
        }
        .contentShape(.rect)
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }

    var demoItemsView: some View {
        VStack(spacing: 8) {
            ForEach(0..<5, id: \.self) { id in
                Text("Элемент # \(id + 1)")
                    .padding(4)
            }
        }
    }
}

#Preview {
    ZStack {
        Text("Стандартное поведение")
            .font(.title.bold())
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 200)
        DrawingGroupAnimationExample()
            .padding()
            .background(Color.yellow)
    }
}

#Preview {
    ZStack {
        Text("Целевое поведение")
            .font(.title.bold())
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 200)
        DrawingGroupAnimationExample()
            .drawingGroup()
            .padding()
            .background(Color.yellow)
    }
}
