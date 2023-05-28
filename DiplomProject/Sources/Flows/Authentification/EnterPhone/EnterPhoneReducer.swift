import ComposableArchitecture
import Core
import UI
import Services

struct EnterPhoneReducer: ReducerProtocol {
    struct State: Equatable {
        var country: Country
        var phoneNumber: String
        var isSendButtonEnabled: Bool
        var isKeyboardActive: Bool
        var isCountySelect: Bool
        var viewState: ViewState
        var availableCountries: [Country]
    }

    enum Action: Equatable {
        case phoneChanged(String)
        case checkPhoneNumber
        case selectCountry
        case closeCountySelect
        case countrySelected(String)
        case dissmissSnack
        case registerUser
        case enterPassword
        case start
        case checkPhoneNumberResponse(TaskResult<Int>)
    }

    private let sessionStorage: SessionStorage
    private let authClient: AuthClient

    init(
        sessionStorage: SessionStorage,
        authClient: AuthClient
    ) {
        self.sessionStorage = sessionStorage
        self.authClient = authClient
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .phoneChanged(let phone):
            state.phoneNumber = phone
            state.isSendButtonEnabled = phone.trimmingCharacters(in: .whitespaces).count == state.country.phoneMask.trimmingCharacters(in: .whitespaces).count
            return .none
        case .checkPhoneNumber:
            let currentState = state
            state.isKeyboardActive = false

            let params = CheckRegistrationParams(phone: state.phoneNumber)

            state.viewState = .loading(.custom)


            return .task { .registerUser }
            return .task {
                await .checkPhoneNumberResponse(
                    TaskResult {
                        try await self.authClient.checkRegistration(with: params)
                    }
                )
            }
        case .selectCountry:
            state.isCountySelect = true
            return .none
        case .countrySelected(let countryId):
            state.isCountySelect = false
            state.phoneNumber = ""
            state.isSendButtonEnabled = false
            state.country = state.availableCountries.first(where: { $0.countryCode == countryId })!
            return .none
        case .closeCountySelect:
            state.isCountySelect = false
            return .none
        case .dissmissSnack:
            guard case .error = state.viewState else { return .none }
            state.viewState = .pending
            return .none
        case .registerUser:
            state.isKeyboardActive = false
            sessionStorage.phoneNumber = "\(state.country.countryCode + state.phoneNumber)".trimmingCharacters(in: .whitespaces)
            return .none
        case .enterPassword:
            return .none
        case .start:
            return .none
        case .checkPhoneNumberResponse(.failure):
            state.viewState = .error(.snack(.init(message: "Ошибка")))

            return .none

        case .checkPhoneNumberResponse(.success(let code)):
            switch code {
            case 200, 403:
                return .task { .enterPassword }
            case 404:
                return .task { .registerUser }
            default:
                state.viewState = .error(.snack(.init(message: "Ошибка")))
                return .none
            }
        }
    }
}
