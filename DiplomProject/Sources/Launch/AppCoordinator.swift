import SwiftUI
import ComposableArchitecture

struct AppCoordinator: View {
    private let store: StoreOf<AppCoordinatorReducer>

    init(store: StoreOf<AppCoordinatorReducer>) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            SwitchStore(self.store) {
                CaseLet(state: /AppCoordinatorReducer.State.login, action: AppCoordinatorReducer.Action.login) { store in
                    AuthentificationFlowView(store: store)
                }
                CaseLet(state: /AppCoordinatorReducer.State.main, action: AppCoordinatorReducer.Action.main) { store in
                    MainCoordinatorView(store: store)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
