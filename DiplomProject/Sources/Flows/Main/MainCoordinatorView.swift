import SwiftUI
import TCACoordinators
import ComposableArchitecture
import UI

struct MainCoordinatorView: View {
    let store: StoreOf<MainFlowCoordinator>
    
    var body: some View {
        TabView {
            MapFlowView(
                store: store.scope(
                    state: \MainFlowCoordinator.State.map,
                    action: MainFlowCoordinator.Action.map
                )
            )
            .tabItem {
                VStack(spacing: 6) {
                    Image(uiImage: Asset.map.image)
                        .frame(width: 20, height: 20)
                    Text("Карта")
                        .font(Font.headline())
                }
            }
            ChatFlowView(
                store: store.scope(
                    state: \MainFlowCoordinator.State.chat,
                    action: MainFlowCoordinator.Action.chat
                )
            )
            .tabItem {
                VStack(spacing: 6) {
                    Image(uiImage: Asset.chat.image)
                        .frame(width: 20, height: 20)
                    Text("Сообщения")
                        .font(Font.headline())
                }
            }
            ProfileFlowView(
                store: store.scope(
                    state: \MainFlowCoordinator.State.profile,
                    action: MainFlowCoordinator.Action.profile
                )
            )
            .tabItem {
                VStack(spacing: 6) {
                    Image(uiImage: Asset.person.image)
                        .frame(width: 20, height: 20)
                    Text("Профиль")
                        .font(Font.headline())
                }
            }
        }
        .accentColor(.Content.accentPrimary)
    }
}
