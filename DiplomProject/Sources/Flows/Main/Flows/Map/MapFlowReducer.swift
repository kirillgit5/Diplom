import ComposableArchitecture
import Core
import UI
import Services
import SwiftUI

struct MapFlowReducer: ReducerProtocol {
    enum State: Equatable {
        case map(MapReducer.State)
    }

    enum Action: Equatable {
        case map(MapReducer.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: /State.map, action: /Action.map) {
            MapReducer()
        }
    }
}
