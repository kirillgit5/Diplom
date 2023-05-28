import ComposableArchitecture
import Core
import UI
import Foundation
import Services

struct EnterPasswordReducer: ReducerProtocol {
    struct State: Equatable {
        var password = ""
        var becomeFirstResponder = true
        var errorText: String?
        var viewState: ViewState = .pending
        var isSendButtonEnabled = false
        var biometryType: Biometry
    }

    enum Action: Equatable {
        case passwordChanged(String)
        case nextButtonTap
        case becomeFirstResponder(Bool)
        case biometryButtonTapped
        case handleBiometricsResult(String?)
        case authorization(String)
        case finishFlow
        case authResponse(TaskResult<AccessTokenResponse>)
    }

    private let quickAccess: QuickAccess
    private let sessionStorage: SessionStorage
    private let authClient: AuthClient


    init(
        quickAccess: QuickAccess,
        authClient: AuthClient,
        sessionStorage: SessionStorage
    ) {
        self.quickAccess = quickAccess
        self.authClient = authClient
        self.sessionStorage = sessionStorage
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .nextButtonTap:
            guard validate(password: state.password) else {
                state.errorText = "Неправильный пароль"
                return .none
            }

            state.viewState = .loading(.custom)

            let params = AccessTokenParams(
                number: sessionStorage.phoneNumber ?? "",
                password: state.password
            )

            return .task {
                await .authResponse(
                    TaskResult {
                        try await self.authClient.auth(with: params)
                    }
                )
            }
        case .passwordChanged(let password):
            state.password = password
            state.isSendButtonEnabled = checkButtonIsEnabled(password: password)
            return .none
        case .becomeFirstResponder(let becomeFirstResponder):
            state.becomeFirstResponder = becomeFirstResponder
            return .none
        case .biometryButtonTapped:
            return .run { send in
                let (pin, _) = await quickAccess.requestPinByBiometry()
                await send(.handleBiometricsResult(pin))
            }
        case .handleBiometricsResult(let pin):
            if let pin = pin {
                return .task { .authorization(pin) }
            } else {
                return .none
            }
        case .authorization(let password):
            state.password = password
            return .task { .nextButtonTap }
        case .authResponse(.failure):
            state.errorText = "Неправильный пароль"
            return .none
        case .authResponse(.success(let response)):
            sessionStorage.accessToken = response.accessToken
            sessionStorage.refreshToken = response.refreshToken
            return .task { .finishFlow }
        case .finishFlow:
            return .none
        }
    }

    private func checkButtonIsEnabled(password: String) -> Bool {
        let validator = Validator(rules: [.minLength(minLen: 6), .maxLength(maxLen: 20)])

        switch validator.validate(password) {
        case .valid: return true
        case .invalid: return false
        }
    }

    private func validate(password: String) -> Bool {
        let validator = Validator(rules: [.latinic, .digit])

        switch validator.validate(password) {
        case .valid: return true
        case .invalid: return false
        }
    }
}
