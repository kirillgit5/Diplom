import ComposableArchitecture
import UI
import SwiftUI

struct EnterPasswordView: View {
    let store: StoreOf<EnterPasswordReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            StateWrapper(
                statePublisher: viewStore.publisher.viewState,
                dismissCallback: {  }
            ) {
                ZStack {
                    VStack() {
                        Spacer()
                            .frame(height: 24)
                        HStack {
                            Text("Введите пароль")
                                .font(.title1())
                                .foregroundColor(.Content.primary)
                            Spacer()
                        }
                        Spacer()
                    }
                    VStack(alignment: .center) {
                        HStack(spacing: 14) {
                            HStack {
                                CustomTextField(
                                    textBind: viewStore.binding(
                                        get: \.password, send: EnterPasswordReducer.Action.passwordChanged
                                    ),
                                    becomeFirstResponder: viewStore.binding(
                                        get: \.becomeFirstResponder,
                                        send: EnterPasswordReducer.Action.becomeFirstResponder
                                    ),
                                    foregroundColor: .Content.primary,
                                    style: .primary,
                                    isSecure: true
                                )
                                .frame(height: 24)
                                .placeholder(
                                    Text("Введите пароль")
                                        .font(Font.body1())
                                        .foregroundColor(.Content.tertiary),
                                    needShow: viewStore.password.isEmpty
                                )
                            }
                            .padding(16)
                            .background(Color.Background.primary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.Controls.primary)
                            )

                            if viewStore.biometryType != .none {
                                Button(
                                    action: {  },
                                    label: {
                                        Image(uiImage: viewStore.biometryType.image)
                                            .resizable()
                                            .frame(width: 56, height: 56)
                                            .foregroundColor(.Content.tertiary)
                                    }
                                    )
                            }
                        }

                        Spacer()
                            .frame(height: 4)
                        if let errorText = viewStore.errorText {
                            Text(errorText)
                                .foregroundColor(.Error.primary)
                                .font(Font.body4())
                        } else {
                            Spacer()
                                .frame(height: 12.6)
                        }
                    }
                    VStack {
                        Spacer()
                        BaseButton(
                            isEnabled: viewStore.isSendButtonEnabled,
                            kind: .primary,
                            text: Text("Send"),
                            accessory: viewStore.viewState.isCustomLoading ? .loader(.rightTitleEdge) : .none,
                            onPress: { viewStore.send(.nextButtonTap) }
                        )
                    }
                }
                .padding()
            }
        }
    }
}
