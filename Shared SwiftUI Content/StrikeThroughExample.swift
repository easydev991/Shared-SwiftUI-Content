//
//  StrikeThroughExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 17.06.2023.
//

import SwiftUI

// 1 - Модель задачи
struct MyTask {
    /// Название задачи
    let text: String
    /// Завершена ли задача
    var isDone: Bool
}

struct StrikeThroughExample: View {
    // 2 - Свойство для хранения списка задач
    @State private var myTasks: [MyTask] = (1...5).map {
        MyTask(text: "Task # \($0)", isDone: false)
    }

    var body: some View {
        VStack(spacing: 16) {
            ForEach($myTasks, id: \.text) { $task in
                Button {
                    // 3 - Меняем свойство isDone
                    task.isDone.toggle()
                } label: {
                    Text(task.text)
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        // 4 - В зависимости от значения isDone перечеркиваем текст
                        .strikethrough(task.isDone, color: .red)
                }
            }
            Button("Reset") {
                // 5 - Сбрасываем все задачи к значению по умолчанию (отменяем перечеркивание)
                myTasks = myTasks.map {
                    MyTask(text: $0.text, isDone: false)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    StrikeThroughExample()
}
