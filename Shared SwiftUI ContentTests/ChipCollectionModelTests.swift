import Testing
@testable import Shared_SwiftUI_Content

struct ChipCollectionModelTests {
    @Test
    func emptyCollection() {
        let model = ChipCollectionModel(items: [])
        #expect(model.rows == 0)
        #expect(model.itemsDict.isEmpty)
    }
    
    @Test
    func singleRowCollection() {
        let items = [
            ChipItem(id: 1, description: "Chips A"),
            ChipItem(id: 2, description: "Chips B"),
            ChipItem(id: 3, description: "Chips C"),
            ChipItem(id: 4, description: "Chips D")
        ]
        
        let model = ChipCollectionModel(items: items)
        
        #expect(model.rows == 1)
        #expect(model.itemsDict.count == 1)
        #expect(model.itemsDict[1]?.count == 4)
        #expect(model.itemsDict[1] == items)
    }
    
    @Test
    func twoRowCollectionEvenCount() {
        let items = [
            ChipItem(id: 1, description: "Chips A"),
            ChipItem(id: 2, description: "Chips B"),
            ChipItem(id: 3, description: "Chips C"),
            ChipItem(id: 4, description: "Chips D"),
            ChipItem(id: 5, description: "Chips E"),
            ChipItem(id: 6, description: "Chips F")
        ]
        
        let model = ChipCollectionModel(items: items)
        
        #expect(model.rows == 2)
        #expect(model.itemsDict.count == 2)
        #expect(model.itemsDict[1]?.count == 3)
        #expect(model.itemsDict[2]?.count == 3)
        #expect(model.itemsDict[1] == Array(items[0...2]))
        #expect(model.itemsDict[2] == Array(items[3...5]))
    }
    
    @Test
    func twoRowCollectionOddCount() {
        let items = [
            ChipItem(id: 1, description: "Chips A"),
            ChipItem(id: 2, description: "Chips B"),
            ChipItem(id: 3, description: "Chips C"),
            ChipItem(id: 4, description: "Chips D"),
            ChipItem(id: 5, description: "Chips E")
        ]
        
        let model = ChipCollectionModel(items: items)
        
        #expect(model.rows == 2)
        #expect(model.itemsDict.count == 2)
        #expect(model.itemsDict[1]?.count == 3)
        #expect(model.itemsDict[2]?.count == 2)
        #expect(model.itemsDict[1] == Array(items[0...2]))
        #expect(model.itemsDict[2] == Array(items[3...4]))
    }
}
