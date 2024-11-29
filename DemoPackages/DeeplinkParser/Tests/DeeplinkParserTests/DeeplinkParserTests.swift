import Testing
import Foundation
@testable import DeeplinkParser

struct DeeplinkParserTests {
    @Test func emptyURL() throws {
        let url = try #require(URL(string: "myapp://"))
        let parser = DeeplinkParser(url: url)
        #expect(parser.path == nil)
    }
    
    @Test func simplePath() throws {
        let url = try #require(URL(string: "myapp://simple"))
        let parser = DeeplinkParser(url: url)
        #expect(parser.path == .simple)
    }

    @Test func complexPathWithId() throws {
        let url = try #require(URL(string: "myapp://complex?id=12345"))
        let parser = DeeplinkParser(url: url)
        #expect(parser.path == .complex(id: "12345"))
    }

    @Test func complexPathWithoutId() throws {
        let url = try #require(URL(string: "myapp://complex"))
        let parser = DeeplinkParser(url: url)
        #expect(parser.path == nil)
    }

    @Test func invalidHost() throws {
        let url = try #require(URL(string: "myapp://unknown"))
        let parser = DeeplinkParser(url: url)
        #expect(parser.path == nil)
    }

    @Test func malformedURL() throws {
        let url = try #require(URL(string: "invalid-url"))
        let parser = DeeplinkParser(url: url)
        #expect(parser.path == nil)
    }
}
