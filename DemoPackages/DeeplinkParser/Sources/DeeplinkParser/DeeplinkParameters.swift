import Foundation

public struct DeeplinkParameters {
    public let dictionary: [String: String]
    
    public init(for url: URL) {
        let urlString = url.absoluteString.removingPercentEncoding ?? url.absoluteString
        let components = URLComponents(string: urlString)
        dictionary = components?.queryItems?.reduce(into: [String: String]()) { result, key in
            result[key.name.lowercased()] = key.value
        } ?? [:]
    }
    
    public subscript(key: String) -> String? {
        dictionary[key.lowercased()]
    }
}
