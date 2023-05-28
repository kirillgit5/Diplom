public enum Server {
    public enum Flow {
        case refresh
        case registration
        case check
        case updateInfo
        case geocode
        case companion
        case driver
    }

    case prod
    case dev

    public func baseUrl(for flow: Flow) -> String {
        switch self {
        case .dev:
            return "https://stoplight.io/mocks/dimlom/dimplom/2763286/"
        case .prod:
            switch flow {
            case .registration, .check, .updateInfo: return "http://185.93.111.89:30225/"
            case .refresh: return "http://185.93.111.89:32602/auth/realms/companion/protocol/openid-connect/"
            case .geocode: return "https://maps.googleapis.com/maps/api/"
            case .companion: return "http://localhost:1257/"
            case .driver: return "http://localhost:1256/"
            }
        }
    }
}
