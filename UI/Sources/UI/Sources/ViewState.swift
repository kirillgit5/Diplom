import Core
import Foundation

public enum ViewState: Equatable {
    case loading(_ style: LoaderStyle)
    case error(PresentationError)
    case pending
}

public extension ViewState {
    var isCustomLoading: Bool {
        if case .loading(let state) = self {
            return state == .custom
        }

        return false
    }

    var isNormalLoading: Bool {
        if case .loading(let state) = self {
            return state == .normal
        }

        return false
    }

    var isSnackError: Bool {
        snackConfig != nil
    }

    var snackConfig: SnackErrorConfig? {
        if case .error(let state) = self {
            guard case .snack(let config) = state else {
                return nil
            }

            return config
        }

        return nil
    }

    var isFullscreenError: Bool {
        return self == .error(.fullscreen)
    }
}

public enum LoaderStyle: Equatable {
    case normal
    case custom
}

public enum PresentationError: Equatable {
    case snack(SnackErrorConfig)
    case fullscreen
}

public struct SnackErrorConfig: Equatable {
    let message: String

    public init(
        message: String
    ) {
        self.message = message
    }
}
