import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct MainFlowCoordinator: ReducerProtocol {
    enum Action: Equatable {
        case profile(ProfileFlowCoordinator.Action)
        case chat(ChatFlowCoordinator.Action)
        case map(MapFlowCoordinator.Action)
    }

    struct State: Equatable {
        static let initialState = State(
            map: .initialState,
            profile: .initialState,
            chat: .initialState
        )

        var map: MapFlowCoordinator.State
        var profile: ProfileFlowCoordinator.State
        var chat: ChatFlowCoordinator.State
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.profile, action: /Action.profile) {
            ProfileFlowCoordinator()
        }
        Scope(state: \.chat, action: /Action.chat) {
            ChatFlowCoordinator()
        }
    }
}
