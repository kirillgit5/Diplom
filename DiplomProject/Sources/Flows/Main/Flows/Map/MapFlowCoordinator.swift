import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct MapFlowCoordinator: ReducerProtocol {
    struct State: Equatable, IndexedRouterState {
        static let initialState = State(routes: [.root(.map(.init()))])

        var routes: [Route<MapFlowReducer.State>]
    }

    enum Action: Equatable, IndexedRouterAction {
        case routeAction(Int, action: MapFlowReducer.Action)
        case updateRoutes([Route<MapFlowReducer.State>])
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce<State, Action> { state, action in
            return .none
        }.forEachRoute {
            MapFlowReducer()
        }
    }
}
