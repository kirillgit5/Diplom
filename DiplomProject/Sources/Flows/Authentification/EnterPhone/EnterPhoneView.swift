import ComposableArchitecture
import UI
import SwiftUI

struct EnterPhoneView: View {
    let store: StoreOf<EnterPhoneReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            StateWrapper(
                statePublisher: viewStore.publisher.viewState,
                dismissCallback: { viewStore.send(.dissmissSnack) }
            ) {
                ZStack {
                    PhoneTextField(
                        text: viewStore.binding(
                            get: \.phoneNumber, send: EnterPhoneReducer.Action.phoneChanged
                        ),
                        becomeFirstResponder: .constant(viewStore.isKeyboardActive),
                        onCountryCodeTap: { viewStore.send(.selectCountry) },
                        countryImage: viewStore.country.flagImage,
                        phoneMask:  Binding(get: { viewStore.country.phoneMask }, set: { _ in } ),
                        phoneCode: viewStore.country.phoneCode,
                        placeholder: "Enter Phone Number"
                    )
                    .padding(16)
                    VStack {
                        Spacer()
                        BaseButton(
                            isEnabled: viewStore.isSendButtonEnabled,
                            kind: .primary,
                            text: Text("Send"),
                            accessory: viewStore.viewState.isCustomLoading ? .loader(.rightTitleEdge) : .none,
                            onPress: { viewStore.send(.checkPhoneNumber) }
                        )
                        Spacer()
                            .frame(height: 16)
                    }
                    .padding(16)
                }
                .disabled(viewStore.viewState.isCustomLoading ? true : false)
                .sheet(isPresented: .init(get: { viewStore.isCountySelect }, set: { isPresented in isPresented ? viewStore.send(.selectCountry) : viewStore.send(.closeCountySelect)})) {
                    PickerView(model: .init(items: viewStore.availableCountries.map {
                        PickerItem(id: $0.countryCode, title: $0.localizedName, description: $0.phoneCode, rightImage: $0.flagImage)
                    },
                               selectedItem: viewStore.binding(
                                get: \.country.countryCode, send: EnterPhoneReducer.Action.countrySelected
                            )
                    ))
                }
            }
        }
    }
}
