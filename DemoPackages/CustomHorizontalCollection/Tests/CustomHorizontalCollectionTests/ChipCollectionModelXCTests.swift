import XCTest
@testable import CustomHorizontalCollection

final class ChipCollectionModelXCTests: XCTestCase {
    
    func testEmptyCollection() {
        let model = ChipCollectionModel(items: [])
        XCTAssertEqual(model.rows, 0)
        XCTAssertTrue(model.itemsDict.isEmpty)
    }
    
    func testSingleRowCollection() {
        let items = [
            ChipItem(id: 1, description: "Chips A"),
            ChipItem(id: 2, description: "Chips B"),
            ChipItem(id: 3, description: "Chips C"),
            ChipItem(id: 4, description: "Chips D")
        ]
        
        let model = ChipCollectionModel(items: items)
        
        XCTAssertEqual(model.rows, 1)
        XCTAssertEqual(model.itemsDict.count, 1)
        XCTAssertEqual(model.itemsDict[1]?.count, 4)
        XCTAssertEqual(model.itemsDict[1], items)
    }
    
    func testTwoRowCollectionEvenCount() {
        let items = [
            ChipItem(id: 1, description: "Chips A"),
            ChipItem(id: 2, description: "Chips B"),
            ChipItem(id: 3, description: "Chips C"),
            ChipItem(id: 4, description: "Chips D"),
            ChipItem(id: 5, description: "Chips E"),
            ChipItem(id: 6, description: "Chips F")
        ]
        
        let model = ChipCollectionModel(items: items)
        
        XCTAssertEqual(model.rows, 2)
        XCTAssertEqual(model.itemsDict.count, 2)
        XCTAssertEqual(model.itemsDict[1]?.count, 3)
        XCTAssertEqual(model.itemsDict[2]?.count, 3)
        XCTAssertEqual(model.itemsDict[1], Array(items[0...2]))
        XCTAssertEqual(model.itemsDict[2], Array(items[3...5]))
    }
    
    func testTwoRowCollectionOddCount() {
        let items = [
            ChipItem(id: 1, description: "Chips A"),
            ChipItem(id: 2, description: "Chips B"),
            ChipItem(id: 3, description: "Chips C"),
            ChipItem(id: 4, description: "Chips D"),
            ChipItem(id: 5, description: "Chips E")
        ]
        
        let model = ChipCollectionModel(items: items)
        
        XCTAssertEqual(model.rows, 2)
        XCTAssertEqual(model.itemsDict.count, 2)
        XCTAssertEqual(model.itemsDict[1]?.count, 3)
        XCTAssertEqual(model.itemsDict[2]?.count, 2)
        XCTAssertEqual(model.itemsDict[1], Array(items[0...2]))
        XCTAssertEqual(model.itemsDict[2], Array(items[3...4]))
    }
}
