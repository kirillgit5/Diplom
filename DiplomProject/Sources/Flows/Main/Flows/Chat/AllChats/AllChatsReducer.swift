import ComposableArchitecture
import Core
import UI
import Services

struct AllChatsReducer: ReducerProtocol {
    struct State: Equatable {}

    enum Action: Equatable {}

    init() {}

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}

