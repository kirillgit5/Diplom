import TCACoordinators
import SwiftUI
import ComposableArchitecture

struct ProfileFlowView: View {
    let store: StoreOf<ProfileFlowCoordinator>

    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) {
                CaseLet(
                    state: /ProfileFlowReducer.State.profile,
                    action: ProfileFlowReducer.Action.profile,
                    then: ProfileView.init
                )
            }
        }
    }
}
