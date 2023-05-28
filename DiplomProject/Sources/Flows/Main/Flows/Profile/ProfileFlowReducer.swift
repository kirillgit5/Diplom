import ComposableArchitecture
import Services
import SwiftUI

struct ProfileFlowReducer: ReducerProtocol {
    enum State: Equatable {
        case profile(ProfileReducer.State)
    }

    enum Action: Equatable {
        case profile(ProfileReducer.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: /State.profile, action: /Action.profile) {
            ProfileReducer(sessionStorage: .shared, homeClient: HomeClient())
        }
    }
}
