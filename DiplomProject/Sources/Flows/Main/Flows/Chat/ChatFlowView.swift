import TCACoordinators
import SwiftUI
import ComposableArchitecture

struct ChatFlowView: View {
    let store: StoreOf<ChatFlowCoordinator>

    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) {
                CaseLet(
                    state: /ChatFlowReducer.State.allChats,
                    action: ChatFlowReducer.Action.allChats,
                    then: AllChatsView.init
                )
            }
        }
    }
}
