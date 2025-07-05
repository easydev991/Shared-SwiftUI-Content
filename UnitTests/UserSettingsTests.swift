import Testing
import Foundation
@testable import Shared_SwiftUI_Content

@Suite("Тесты для настроек пользователя")
struct UserSettingsTests {
    private typealias SUT = UserSettings
    
    @Test("Корректный init")
    func initCorrect() {
        let sut = SUT()
        #expect(!sut.isSoundOn)
        #expect(sut.totalScore == 0)
        #expect(sut.highScore == 0)
        #expect(sut.lastGameMode == nil)
        #expect(sut.highScoreDate == nil)
    }
    
    @Test("init с параметрами")
    func initWithParameters() {
        let date = Date()
        let sut = SUT(
            isSoundOn: true,
            totalScore: 100,
            highScore: 500,
            lastGameMode: "Classic",
            highScoreDate: date
        )
        
        #expect(sut.isSoundOn)
        #expect(sut.totalScore == 100)
        #expect(sut.highScore == 500)
        #expect(sut.lastGameMode == "Classic")
        #expect(sut.highScoreDate == date)
    }
    
    @Test("soundText когда звук включен")
    func soundTextWhenSoundOn() {
        let sut = SUT(isSoundOn: true)
        #expect(sut.soundText == "включен")
    }
    
    @Test("soundText когда звук выключен")
    func soundTextWhenSoundOff() {
        let sut = SUT(isSoundOn: false)
        #expect(sut.soundText == "выключен")
    }
    
    @Test("highScoreText когда есть рекорд")
    func highScoreTextWhenHasHighScore() {
        let sut = SUT(highScore: 1000)
        #expect(sut.highScoreText == "1000")
    }
    
    @Test("highScoreText когда нет рекорда")
    func highScoreTextWhenNoHighScore() {
        let sut = SUT(highScore: 0)
        #expect(sut.highScoreText == "нет рекорда")
    }
    
    @Test("lastGameModeText когда есть режим")
    func lastGameModeTextWhenHasMode() {
        let sut = SUT(lastGameMode: "Arcade")
        #expect(sut.lastGameModeText == "Arcade")
    }
    
    @Test("lastGameModeText когда нет режима")
    func lastGameModeTextWhenNoMode() {
        let sut = SUT(lastGameMode: nil)
        #expect(sut.lastGameModeText == "нет")
    }
    
    @Test("isEmpty возвращает true для пустых настроек")
    func isEmptyReturnsTrueForEmptySettings() {
        let sut = SUT()
        #expect(sut.isEmpty)
    }
    
    @Test("isEmpty возвращает false для непустых настроек")
    func isEmptyReturnsFalseForNonEmptySettings() {
        let sut = SUT(isSoundOn: true, totalScore: 100)
        #expect(!sut.isEmpty)
    }
    
    @Test("static random создает валидные настройки")
    func staticRandomCreatesValidSettings() {
        let sut = SUT.random
        #expect(sut.totalScore >= 0 && sut.totalScore <= 1000)
        #expect(sut.highScore >= 0 && sut.highScore <= 1000)
        #expect(sut.highScoreDate != nil)
    }
    
    @Test("rawValue корректно сериализует данные")
    func rawValueCorrectlySerializes() {
        let date = Date(timeIntervalSince1970: 1733400000)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: date)
        
        let sut = SUT(
            isSoundOn: true,
            totalScore: 150,
            highScore: 750,
            lastGameMode: "Time Attack",
            highScoreDate: date
        )
        
        let expected = "true|150|750|Time Attack|\(dateString)"
        #expect(sut.rawValue == expected)
    }
    
    @Test("init?(rawValue:) корректно десериализует данные")
    func initRawValueCorrectlyDeserializes() throws {
        let date = Date(timeIntervalSince1970: 1733400000)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: date)
        
        let rawValue = "true|200|1000|Classic|\(dateString)"
        let sut = try #require(UserSettings(rawValue: rawValue))
        let highScoreDate = try #require(sut.highScoreDate)
        
        #expect(sut.isSoundOn)
        #expect(sut.totalScore == 200)
        #expect(sut.highScore == 1000)
        #expect(sut.lastGameMode == "Classic")
        #expect(highScoreDate.timeIntervalSince1970 == date.timeIntervalSince1970)
    }
    
    @Test("init?(rawValue:) возвращает nil для пустой строки")
    func initRawValueReturnsNilForEmptyString() {
        let sut = UserSettings(rawValue: "")
        #expect(sut == nil)
    }
    
    @Test("init?(rawValue:) возвращает nil для неправильного формата")
    func initRawValueReturnsNilForWrongFormat() {
        let sut = UserSettings(rawValue: "true|100")
        #expect(sut == nil)
    }
    
    @Test("init?(rawValue:) возвращает nil для некорректных чисел")
    func initRawValueReturnsNilForInvalidNumbers() {
        let sut = UserSettings(rawValue: "true|abc|100||")
        #expect(sut == nil)
    }
    
    @Test("init?(rawValue:) возвращает nil, если заполнены не все поля", arguments: [
        "true",
        "true|100",
        "true|100|200",
        "true|100|200|mode",
        "true|100|200|mode|2025-07-05T10:12:42Z|extra",
        "true|100|200|mode|2025-07-05T10:12:42Z|extra|more"
    ])
    func initRawValueHandlesEmptyFields(rawValue: String) {
        let sut = UserSettings(rawValue: rawValue)
        #expect(sut == nil)
    }
    
    @Test("цикл сериализации-десериализации")
    func serializationDeserializationCycle() throws {
        let original = SUT(
            isSoundOn: true,
            totalScore: 300,
            highScore: 1500,
            lastGameMode: "Survival",
            highScoreDate: Date(timeIntervalSince1970: 1733400000)
        )
        
        let rawValue = original.rawValue
        let deserialized = try #require(UserSettings(rawValue: rawValue))
        let originalHighScoreDate = try #require(original.highScoreDate)
        let deserializedHighScoreDate = try #require(deserialized.highScoreDate)
        
        #expect(deserialized.isSoundOn == original.isSoundOn)
        #expect(deserialized.totalScore == original.totalScore)
        #expect(deserialized.highScore == original.highScore)
        #expect(deserialized.lastGameMode == original.lastGameMode)
        #expect(originalHighScoreDate.timeIntervalSince1970 == deserializedHighScoreDate.timeIntervalSince1970)
    }
}
