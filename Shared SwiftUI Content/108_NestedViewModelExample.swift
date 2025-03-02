import SwiftUI

final class ParentDemoViewModel: ObservableObject {
    final class ChildDemoViewModel: ObservableObject {
        @Published var childViewModelText = "Текст вложенной вьюмодели"
    }
    @Published var demoObservedText = ""
    let childViewModel = ChildDemoViewModel()
    @Published private var childWillChange: Void = ()

    init() {
        // Точечное обновление одного поля
        childViewModel.$childViewModelText.assign(to: &$demoObservedText)
        // Обновление всей вьюмодели
//        childViewModel.objectWillChange.assign(to: &$childWillChange)
    }
}

struct ParentDemoView: View {
    @StateObject private var viewModel = ParentDemoViewModel()
    @State private var showTopOverlay = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Снаружи: \(viewModel.demoObservedText)")
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.green)
            Text("Внутри: \(viewModel.childViewModel.childViewModelText)")
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.yellow)
            ChildDemoView(viewModel: viewModel.childViewModel)
            Button("Print") {
                withAnimation(.spring(duration: 0.15)) {
                    showTopOverlay.toggle()
                }
                print(viewModel.childViewModel.childViewModelText)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: viewModel.childViewModel.childViewModelText) { newValue in
            viewModel.demoObservedText = newValue
        }
        .overlay(alignment: .top) {
            if showTopOverlay {
                Text(viewModel.childViewModel.childViewModelText)
            }
        }
    }
}

struct ChildDemoView: View {
    @ObservedObject var viewModel: ParentDemoViewModel.ChildDemoViewModel
    
    var body: some View {
        TextField("Текст", text: $viewModel.childViewModelText)
            .textFieldStyle(.roundedBorder)
    }
}

#Preview {
    ParentDemoView()
}
