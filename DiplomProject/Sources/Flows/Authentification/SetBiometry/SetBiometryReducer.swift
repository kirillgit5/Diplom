import ComposableArchitecture
import Core
import Services
import SwiftUI
import UI

struct SetBiometryReducer: ReducerProtocol {
    struct State: Equatable {
        let title: String
        let description: String
        var viewState: ViewState = .pending
        let image: UIImage
    }

    enum Action: Equatable {
        static func == (lhs: SetBiometryReducer.Action, rhs: SetBiometryReducer.Action) -> Bool {
            switch (lhs, rhs) {
            case (.allowBiometryButtonTapped, .allowBiometryButtonTapped): return true
            case (.skip, .skip): return true
            case (.allowBiometry, .allowBiometry): return true
            default: return false
            }
        }

        case allowBiometryButtonTapped
        case skip
        case allowBiometry(Result<Bool, Error>)
        case dissmissSnack
        case next
    }

    private let quickAccess: QuickAccess

    init(quickAccess: QuickAccess) {
        self.quickAccess = quickAccess
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .skip:
            return .none
        case .allowBiometryButtonTapped:
            return .run { send in
                let status = await self.quickAccess.requestBiometryAuthentication()
                await send(.allowBiometry(status))
            }
        case .allowBiometry(let result):
            switch result {
            case .success:
                return .task { .next }
            case .failure:
                state.viewState = .error(.snack(.init(message: "Ошибка")))
            }

            return .none
        case .dissmissSnack:
            state.viewState = .pending
            return .none
        case .next:
            return .none
        }
    }
}
