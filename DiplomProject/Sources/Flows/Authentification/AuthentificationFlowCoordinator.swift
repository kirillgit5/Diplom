import SwiftUI
import ComposableArchitecture
import Services
import TCACoordinators

struct AuthentificationFlowCoordinator: ReducerProtocol {
    struct State: Equatable, IndexedRouterState {
        var routes: [Route<AuthentificationFlowReducer.State>]
      }

    enum Action: Equatable, IndexedRouterAction {
        case routeAction(Int, action: AuthentificationFlowReducer.Action)
        case updateRoutes([Route<AuthentificationFlowReducer.State>])
        case finishFlow
      }

    enum Screen: Equatable {
        case enterPhone
        case registrationForm
        case enterPassword
        case setBiometry
    }


    var body: some ReducerProtocol<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .routeAction(_, .enterPhone(.registerUser)):
                state.routes.push(.registrationForm(RegistrationFormStateBuilder().buildInitialState()))
            case .routeAction(_, .enterPhone(.enterPassword)):
                state.routes.push(.enterPassword(EnterPasswordStateBuilder(quickAccess: .init(sessionStorage: .shared)).buildInitialState()))
            case .routeAction(_, .enterPassword(.finishFlow)):
                return .task { .finishFlow }
            case .routeAction(_, .registrationForm(.finishFlow)):
                return .task { .finishFlow }
            default:
                break
            }

            return .none
        }.forEachRoute {
            AuthentificationFlowReducer()
        }
    }
}
