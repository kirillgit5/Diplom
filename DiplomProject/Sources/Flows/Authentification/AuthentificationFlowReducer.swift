import ComposableArchitecture
import Services
import FlowStacks
import SwiftUI

struct AuthentificationFlowReducer: ReducerProtocol {
    enum State: Equatable {
        case start
        case enterPhone(EnterPhoneReducer.State)
        case registrationForm(RegistrationFormReducer.State)
        case enterPassword(EnterPasswordReducer.State)
        case setBiometry(SetBiometryReducer.State)
    }

    enum Action: Equatable {
        case start
        case enterPhone(EnterPhoneReducer.Action)
        case registrationForm(RegistrationFormReducer.Action)
        case enterPassword(EnterPasswordReducer.Action)
        case setBiometry(SetBiometryReducer.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: /State.enterPhone, action: /Action.enterPhone) {
            EnterPhoneReducer(sessionStorage: SessionStorage.shared, authClient: AuthClient())
        }

        Scope(state: /State.registrationForm, action: /Action.registrationForm) {
            RegistrationFormReducer(sessionStorage: SessionStorage.shared, authClient: AuthClient())
        }

        Scope(state: /State.enterPassword, action: /Action.enterPassword) {
            EnterPasswordReducer(
                quickAccess: .init(sessionStorage: SessionStorage.shared),
                authClient: AuthClient(),
                sessionStorage: SessionStorage.shared
            )
        }

        Scope(state: /State.setBiometry, action: /Action.setBiometry) {
            SetBiometryReducer(
                quickAccess: .init(sessionStorage: SessionStorage.shared)
            )
        }
    }

//    var body: some ReducerProtocol<State, Action> {
//        Reduce { state, action in
//            switch action {
//            case .enterPhone(.registerUser):
//                state = .registrationForm(RegistrationFormStateBuilder().buildInitialState())
//                return .none
//            case .enterPhone(.enterPassword):
//                state = .enterPassword(EnterPasswordStateBuilder(quickAccess: .init(sessionStorage: .init(keychainStorage: .init()))).buildInitialState())
//                return .none
//            case .enterPhone:
//                return .none
//
//            case .enterPassword(.next):
//                return .none
//            case .enterPassword:
//                return .none
//
//            case .setBiometry(.next), .setBiometry(.skip):
//                return .none
//            case .setBiometry:
//                return .none
//
//            case .registrationForm(.next):
//                state = .setBiometry(SetBiometryStateBuilder(quickAccess: QuickAccess(
//                    sessionStorage: SessionStorage(keychainStorage: KeychainStorage())
//                )).buildInitialState())
//                return .none
//            case .registrationForm(.back):
//                state = .enterPhone(EnterPhoneStateBuilder(countriesListService: CountriesListService()).buildInitialState())
//
//                return .none
//            case .registrationForm:
//                return .none
//
//            case .finish:
//                return .none
//            }
//        }
//        .ifCaseLet(/State.enterPhone, action: /Action.enterPhone) {
//            EnterPhoneReducer()
//        }
//        .ifCaseLet(/State.registrationForm, action: /Action.registrationForm) {
//            RegistrationFormReducer()
//        }
//        .ifCaseLet(/State.enterPassword, action: /Action.enterPassword) {
//            EnterPasswordReducer(quickAccess: .init(sessionStorage: .init(keychainStorage: .init())))
//        }
//        .ifCaseLet(/State.setBiometry, action: /Action.setBiometry) {
//            SetBiometryReducer(quickAccess: .init(sessionStorage: .init(keychainStorage: .init())))
//        }
//    }
}
