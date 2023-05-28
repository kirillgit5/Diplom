import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct AllChatsFlowCoordinator: ReducerProtocol {
    struct State: Equatable, IndexedRouterState {
        static let initialState = State(routes: [.root(.profile(ProfileStateBuilder(sessionStorage: .shared).buildInitialState()))])

        var routes: [Route<ProfileFlowReducer.State>]
    }

    enum Action: Equatable, IndexedRouterAction {
        case routeAction(Int, action: ProfileFlowReducer.Action)
        case updateRoutes([Route<ProfileFlowReducer.State>])
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce<State, Action> { state, action in
            return .none
        }.forEachRoute {
            ProfileFlowReducer()
        }
    }
}
