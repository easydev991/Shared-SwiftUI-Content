//
//  AppStorageCustomTypeExample.swift
//  Shared SwiftUI Content
//
//  Created by Еременко Олег Николаевич on 05.07.2025.
//

import SwiftUI

struct UserSettings: RawRepresentable {
    static var random: Self {
        .init(
            isSoundOn: Bool.random(),
            totalScore: Int.random(in: 0...1000),
            highScore: Int.random(in: 0...1000),
            lastGameMode: ["easy", "medium", "hard"].randomElement(),
            highScoreDate: Date.now.addingTimeInterval(TimeInterval.random(in: 0...86400))
        )
    }
    var isSoundOn: Bool
    var totalScore: Int
    var highScore: Int
    var lastGameMode: String?
    var highScoreDate: Date?
    
    init(
        isSoundOn: Bool = false,
        totalScore: Int = 0,
        highScore: Int = 0,
        lastGameMode: String? = nil,
        highScoreDate: Date? = nil
    ) {
        self.isSoundOn = isSoundOn
        self.totalScore = totalScore
        self.highScore = highScore
        self.lastGameMode = lastGameMode
        self.highScoreDate = highScoreDate
    }
    
    var isEmpty: Bool {
        self == .init()
    }

    var soundText: String {
        isSoundOn ? "включен" : "выключен"
    }

    var highScoreText: String {
        highScore > 0 ? "\(highScore)" : "нет рекорда"
    }

    var lastGameModeText: String {
        lastGameMode ?? "нет"
    }
    
    // MARK: - RawRepresentable
    
    init?(rawValue: String) {
        guard !rawValue.isEmpty else {
            return nil
        }
        let components = rawValue.split(separator: "|")
        guard components.count == 5 else {
            return nil
        }
        
        // Парсим isSoundOn
        let isSoundOn = String(components[0]) == "true"
        
        // Парсим totalScore
        let totalScore = Int(String(components[1])) ?? 0
        
        // Парсим highScore
        let highScore = Int(String(components[2])) ?? 0
        
        // Парсим lastGameMode
        let lastGameMode = components[3].isEmpty ? nil : String(components[3])
        
        // Парсим highScoreDate
        let highScoreDate: Date?
        if components[4].isEmpty {
            highScoreDate = nil
        } else {
            let formatter = ISO8601DateFormatter()
            highScoreDate = formatter.date(from: String(components[4]))
        }
        self.isSoundOn = isSoundOn
        self.totalScore = totalScore
        self.highScore = highScore
        self.lastGameMode = lastGameMode
        self.highScoreDate = highScoreDate
    }
    
    var rawValue: String {
        let formatter = ISO8601DateFormatter()
        let dateString = highScoreDate.map { formatter.string(from: $0) } ?? formatter.string(from: .now)
        return "\(isSoundOn)|\(totalScore)|\(highScore)|\(lastGameMode ?? "нет")|\(dateString)"
    }
}

struct AppStorageCustomTypeExample: View {
    @AppStorage("userSettings") private var userSettings = UserSettings()
    
    var body: some View {
        NavigationView {
            List {
                Toggle("Звук", isOn: $userSettings.isSoundOn)
                makeRowView("Общий счет", "\(userSettings.totalScore)")
                makeRowView("Рекорд", userSettings.highScoreText)
                makeRowView("Последний режим игры", userSettings.lastGameModeText)
            }
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !userSettings.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Сбросить") {
                            userSettings = .init()
                        }
                        .foregroundStyle(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Перемешать") {
                        userSettings = .random
                    }
                }
            }
        }
    }
    
    private func makeRowView(_ title: String, _ description: String) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(description)
        }
    }
}

#Preview {
    AppStorageCustomTypeExample()
}
