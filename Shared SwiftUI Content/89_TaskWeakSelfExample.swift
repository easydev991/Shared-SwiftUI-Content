//
//  TaskWeakSelfExample.swift
//  SUI_Interview
//
//  Created by Oleg Eremenko on 14.10.2024.
//

import SwiftUI

// @unchecked Sendable используется для сохранения работоспособности примера в Swift < 6
final class DemoTaskViewModel: @unchecked Sendable {
    private var demoInt = 0
    
    func runTask() {
        Task { [weak self] in
            print("стартовали таск, int = \(String(describing: self?.demoInt))")
            try? await Task.sleep(nanoseconds: 3000000000)
            guard let self else { return }
            let randomInt = Int.random(in: 0...100000)
            self.demoInt = randomInt
            print("таск завершился, int = \(self.demoInt)")
        }
    }
    
    func runAsyncTask() async {
        print("стартовали async-таск, int = \(demoInt)")
        try? await Task.sleep(nanoseconds: 3000000000)
        guard !Task.isCancelled else { return }
        let randomInt = Int.random(in: 0...100000)
        demoInt = randomInt
        print("async-таск завершился, int = \(demoInt)")
    }
}


struct DemoTaskRootView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: DemoTaskChildView()) {
                    Text("Вперед в SwiftUI")
                }
                NavigationLink(destination: DemoHost()) {
                    Text("Вперед в UIKit")
                }
            }
        }
    }
}

struct DemoTaskChildView: View {
    private let vm = DemoTaskViewModel()
    
    var body: some View {
        Color.clear
            .onAppear(perform: vm.runTask)
            .task { await vm.runAsyncTask() }
    }
}

final class DemoTaskVC: UIViewController {
    private let vm = DemoTaskViewModel()
    private var demoTask: Task<Void, Never>? // <- храним ссылку для отмены таска из второго метода
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.runTask()
        demoTask = Task {
            await vm.runAsyncTask()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        demoTask?.cancel() // <- отменяем таск из второго метода
    }
}

struct DemoHost: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        DemoTaskVC()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

#Preview {
    DemoTaskRootView()
}
