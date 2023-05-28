import UI
import Core
import SwiftUI
import ComposableArchitecture

struct SetBiometryView: View {
    let store: StoreOf<SetBiometryReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            StateWrapper(
                statePublisher: viewStore.publisher.viewState,
                dismissCallback: { viewStore.send(.dissmissSnack) }
            ) {
                VStack {
                    Spacer()
                    Image(uiImage: viewStore.image)
                        .foregroundColor(.Content.accentPrimary)
                    Spacer()
                        .frame(height: 95)
                    Text(viewStore.title)
                        .font(.title1())
                        .foregroundColor(.Content.primary)
                    Spacer()
                        .frame(height: 16)
                    Text(viewStore.description)
                        .font(.body1())
                        .foregroundColor(.Content.tertiary)
                    Spacer()
                        .frame(height: 54)
                    BaseButton(
                        isEnabled: true,
                        kind: .secondary,
                        text: Text("Skip"),
                        accessory: .none,
                        onPress: { viewStore.send(.skip) }
                    )
                    Spacer()
                        .frame(height: 16)
                    BaseButton(
                        isEnabled: true,
                        kind: .primary,
                        text: Text("Allow Biometry"),
                        accessory: .none,
                        onPress: { viewStore.send(.allowBiometryButtonTapped) }
                    )
                }
                .padding()
            }
        }
    }
}
