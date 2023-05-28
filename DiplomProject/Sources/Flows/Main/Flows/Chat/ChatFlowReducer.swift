import ComposableArchitecture
import Services
import SwiftUI

struct ChatFlowReducer: ReducerProtocol {
    enum State: Equatable {
        case allChats(AllChatsReducer.State)
    }

    enum Action: Equatable {
        case allChats(AllChatsReducer.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: /State.allChats, action: /Action.allChats) {
            AllChatsReducer()
        }
    }
}
