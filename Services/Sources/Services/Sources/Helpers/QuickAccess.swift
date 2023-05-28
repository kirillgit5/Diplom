import LocalAuthentication
import Core

public final class QuickAccess {

    private enum State {
        case enabled
        case disabled
    }

    public var biometry: Biometry {
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return .none }

        return Biometry.map(context.biometryType)
    }

    public var isBiometrySupportedByDevice: Bool { biometry != .none  }

    public var isBiometryAllowedForUse: Bool {
        .enabled == state && biometry != .none
    }

    private var context: LAContext = {
        let context = LAContext()
        context.localizedFallbackTitle = ""
        return context
    }()

    private var state: State {
        if sessionStorage.password == nil || sessionStorage.refreshToken == nil {
            return .disabled
        } else {
            return sessionStorage.isBiometryUsed == true ? .enabled : .enabled
        }
    }

    private var error: NSError?

    private let sessionStorage: SessionStorage

    public init(sessionStorage: SessionStorage) {
        self.sessionStorage = sessionStorage
    }

    public func requestPinByBiometry() async -> (String?, Error?) {
        switch await requestBiometryAuthentication() {
        case .success:
            return (self.sessionStorage.password, nil)
        case .failure(let error):
            return (nil, error)
        }
    }

    public func requestBiometryAuthentication() async -> Result<Bool, Error> {
        remakeContext()

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            var reason = ""

            switch biometry {
            case .faceID: reason = "faceID"
            case .touchID: reason = "touchID"
            default: break
            }

            do {
                let result = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                return .success(result)
            } catch let error {
                return .failure(error)
            }
        } else {
            return .failure(error!)
        }
    }

    private func remakeContext() {
        context = LAContext()
    }

    private func reset() {
        context = LAContext()
        context.localizedFallbackTitle = ""
    }
}
