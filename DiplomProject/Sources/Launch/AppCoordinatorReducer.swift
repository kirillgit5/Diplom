import ComposableArchitecture
import Services

struct AppCoordinatorReducer: ReducerProtocol {
    enum State: Equatable {
        case login(AuthentificationFlowCoordinator.State)
        case main(MainFlowCoordinator.State)
    }

    enum Action: Equatable {
        case login(AuthentificationFlowCoordinator.Action)
        case main(MainFlowCoordinator.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in

            switch action {
            case .login(.finishFlow):
                state = .main(.initialState)
                return .none
            case .main:
                return .none
            default:
                return .none
            }
        }
        .ifCaseLet(/State.login, action: /Action.login) {
            AuthentificationFlowCoordinator()
        }
        .ifCaseLet(/State.main, action: /Action.main) {
            MainFlowCoordinator()
        }
    }
}
