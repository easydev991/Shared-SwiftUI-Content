import Foundation

public struct DeeplinkParser {
    private let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public var path: Path? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = components.host
        else { return nil }
        let params = components.queryItems?.reduce(into: [String: Any]()) { result, queryItem in
            if let value = queryItem.value {
                result[queryItem.name] = value
            }
        } ?? [:]
        return Path(host: host, params: params)
    }
}

extension DeeplinkParser {
    public enum Path: Equatable {
        /// `easydev991://simple`
        case simple
        /// `easydev991://complex?id=<id>`
        case complex(id: String)
        
        public init?(host: String, params: [String: Any]) {
            switch (host, params) {
            case ("simple", _):
                self = .simple
            case let ("complex", params):
                guard let id = params["id"] as? String else {
                    return nil
                }
                self = .complex(id: id)
            default:
                return nil
            }
        }
    }
}
