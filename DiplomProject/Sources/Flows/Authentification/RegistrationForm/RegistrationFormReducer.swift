import ComposableArchitecture
import Core
import UI
import Foundation
import Services

struct RegistrationFormReducer: ReducerProtocol {
    typealias Key = RegistrationFormView.FieldKey
    typealias SelectorState = DropdownSelectorState

    struct State: Equatable {
        var fieldsModel: RegistrationFormFieldsModel
        var dateSelectorState: SelectorState
        let dateRange: ClosedRange<Date>
        var selectedDateText: String
        var selectedDate: Date
        var viewState: ViewState = .pending
    }

    enum Action: Equatable {
        case fieldValueDidChange(Key, String)
        case fieldStateDidChange(Key, Bool)
        case registerUser
        case changeSelectorState(SelectorState)
        case selectDate(Date)
        case finishFlow
        case back
        case registerUserResponse(TaskResult<Int>)
        case authResponse(TaskResult<AccessTokenResponse>)
    }

    private let sessionStorage: SessionStorage
    private let authClient: AuthClient

    init(
        sessionStorage: SessionStorage,
        authClient: AuthClient
    ) {
        self.authClient = authClient
        self.sessionStorage = sessionStorage
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fieldValueDidChange(let key, let value):
            state.fieldsModel.set(value: value, for: key)
            return .none
        case .fieldStateDidChange(let key, let isFirstResponser):
            state.fieldsModel.set(isFirstResponser: isFirstResponser, for: key)

            if isFirstResponser {
                state.dateSelectorState = .collapse
            }

            return .none
        case .registerUser:
//            guard state.fieldsModel.validate() else { return .none }

            let params: RegistrationParams = .init(
                name: state.fieldsModel.value(by: .name),
                surname: state.fieldsModel.value(by: .surname),
                email: state.fieldsModel.value(by: .email),
                password: state.fieldsModel.value(by: .password),
                birthDate: state.selectedDateText,
                phone: sessionStorage.phoneNumber ?? ""
            )

            state.viewState = .loading(.custom)

            return .task { .finishFlow }
            return .task {
                await .registerUserResponse(TaskResult { try await self.authClient.registration(with: params) })
            }
        case .changeSelectorState(let selectorState):
            state.dateSelectorState = selectorState
            state.fieldsModel.fields.keys.forEach { state.fieldsModel.set(isFirstResponser: false, for: $0) }
            return .none
        case .selectDate(let date):
            state.selectedDateText = date.stringRepresentation(with: .daySlashMonthSlashYear)
            state.selectedDate = date
            return .none
        case .registerUserResponse(.failure):
            state.viewState = .error(.snack(.init(message: "Ошибка")))
            return .none
        case .registerUserResponse(.success(let code)):
            switch code {
            case 201:
                let params = AccessTokenParams(
                    number: sessionStorage.phoneNumber ?? "",
                    password: state.fieldsModel.value(by: .password)
                )

                return .task {
                    await .authResponse(
                        TaskResult {
                            try await self.authClient.auth(with: params)
                        }
                    )
                }
            case 409:
                state.viewState = .error(.snack(.init(message: "Ошибка")))
            default:
                state.viewState = .error(.snack(.init(message: "Ошибка")))
            }

            return .none
        case .finishFlow:
            return .none
        case .back:
            return .none
        case .authResponse(.failure):
            state.viewState = .error(.snack(.init(message: "Ошибка")))
            return .none
        case .authResponse(.success(let response)):
            sessionStorage.accessToken = response.accessToken
            sessionStorage.refreshToken = response.refreshToken
            sessionStorage.firstName = state.fieldsModel.value(by: .name)
            sessionStorage.surname = state.fieldsModel.value(by: .surname)
            return .task { .finishFlow }
        }
    }
}
