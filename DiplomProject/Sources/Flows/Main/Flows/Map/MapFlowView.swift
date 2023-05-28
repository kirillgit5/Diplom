import TCACoordinators
import SwiftUI
import ComposableArchitecture

struct MapFlowView: View {
    let store: StoreOf<MapFlowCoordinator>

    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) {
                CaseLet(
                    state: /MapFlowReducer.State.map,
                    action: MapFlowReducer.Action.map,
                    then: MapView.init
                )
            }
        }
    }
}
