import TCACoordinators
import SwiftUI
import ComposableArchitecture

struct AuthentificationFlowView: View {
    let store: StoreOf<AuthentificationFlowCoordinator>

    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) {
                CaseLet(
                    state: /AuthentificationFlowReducer.State.enterPhone,
                    action: AuthentificationFlowReducer.Action.enterPhone,
                    then: EnterPhoneView.init
                )
                CaseLet(
                    state: /AuthentificationFlowReducer.State.registrationForm,
                    action: AuthentificationFlowReducer.Action.registrationForm,
                    then: RegistrationFormView.init
                )
                CaseLet(
                    state: /AuthentificationFlowReducer.State.enterPassword,
                    action: AuthentificationFlowReducer.Action.enterPassword,
                    then: EnterPasswordView.init
                )
                CaseLet(
                    state: /AuthentificationFlowReducer.State.setBiometry,
                    action: AuthentificationFlowReducer.Action.setBiometry,
                    then: SetBiometryView.init
                )
            }
        }
    }
}
