public enum Environment: Int, CaseIterable {
    case prod

    public var server: Server {
        switch self {
        case .prod: return .prod
        }
    }
}
