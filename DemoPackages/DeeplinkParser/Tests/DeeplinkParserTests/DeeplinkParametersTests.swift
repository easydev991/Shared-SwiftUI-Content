import Testing
import Foundation
@testable import DeeplinkParser

struct DeeplinkParametersTests {
    @Test func emptyURL() throws {
        let url = try #require(URL(string: "myapp://"))
        let parameters = DeeplinkParameters(for: url)
        #expect(parameters.dictionary.isEmpty)
    }
    
    @Test func singleQueryParameter() throws {
        let url = try #require(URL(string: "myapp://path?param1=value1"))
        let parameters = DeeplinkParameters(for: url)
        #expect(parameters["param1"] == "value1")
    }
    
    @Test func multipleQueryParameters() throws {
        let url = try #require(URL(string: "myapp://path?param1=value1&param2=value2"))
        let parameters = DeeplinkParameters(for: url)
        #expect(parameters["param1"] == "value1")
        #expect(parameters["param2"] == "value2")
    }
    
    @Test func caseInsensitiveParameterAccess() throws {
        let url = try #require(URL(string: "myapp://path?Param1=VALUE1"))
        let parameters = DeeplinkParameters(for: url)
        #expect(parameters["param1"] == "VALUE1")
    }
    
    @Test func missingParameter() throws {
        let url = try #require(URL(string: "myapp://path?param1=value1"))
        let parameters = DeeplinkParameters(for: url)
        #expect(parameters["param2"] == nil)
    }
    
    @Test func malformedURL() throws {
        let url = try #require(URL(string: "invalid-url"))
        let parameters = DeeplinkParameters(for: url)
        #expect(parameters.dictionary.isEmpty)
    }
}
