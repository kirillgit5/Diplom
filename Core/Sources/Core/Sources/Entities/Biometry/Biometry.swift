import LocalAuthentication

public enum Biometry: String {
    case touchID
    case faceID
    case none
}

public extension Biometry {
    var name: String {
        switch self {
        case .touchID: return "Touch ID"
        case .faceID: return "Face ID"
        case .none: return ""
        }
    }

    static func map(_ type: LABiometryType) -> Self {
        switch type {
        case .faceID: return .faceID
        case .touchID: return .touchID
        case .none: return .none
        @unknown default: return .none
        }
    }
}
