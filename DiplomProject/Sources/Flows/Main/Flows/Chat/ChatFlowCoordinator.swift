import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct ChatFlowCoordinator: ReducerProtocol {
    struct State: Equatable, IndexedRouterState {
        static let initialState = State(routes: [.root(.allChats(.init()))])

        var routes: [Route<ChatFlowReducer.State>]
    }

    enum Action: Equatable, IndexedRouterAction {
        case routeAction(Int, action: ChatFlowReducer.Action)
        case updateRoutes([Route<ChatFlowReducer.State>])
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce<State, Action> { state, action in
            return .none
        }.forEachRoute {
            ChatFlowReducer()
        }
    }
}
