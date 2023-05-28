//
//  DiplomProjectApp.swift
//  DiplomProject
//
//  Created by KK on 09.01.2023.
//

import SwiftUI
import UI
import ComposableArchitecture
import Services
//import GoogleMaps

@main
struct DiplomProjectApp: App {
    @State var isOn: Bool = true
    var body: some Scene {
        WindowGroup {
//            EnterPhoneView(
//                store: Store(
//                    initialState: EnterPhoneStateBuilder(countriesListService: CountriesListService()).buildInitialState(),
//                    reducer: EnterPhoneReducer()
//                )
//            )
//            RegistrationFormView(
//                store: Store(
//                    initialState: RegistrationFormStateBuilder().buildInitialState(),
//                    reducer: RegistrationFormReducer()
//                )
//            )
//            EnterPasswordView(store: Store(
//                initialState: EnterPasswordStateBuilder(quickAccess: .init(sessionStorage: .init(keychainStorage: .init()))).buildInitialState(),
//                reducer: EnterPasswordReducer(quickAccess: .init(sessionStorage: .init(keychainStorage: .init())))
//            )
//            )
//            AppCoordinator(store: Store(
//                initialState: .login(AuthentificationFlowReducer.State.enterPhone()),
//                reducer: EnterPhoneReducer()
//            )
//            )
//            AppCoordinator(store: .init(initialState: .login(.enterPhone( EnterPhoneStateBuilder(countriesListService: CountriesListService()).buildInitialState())), reducer: AppCoordinatorReducer()))
            AppCoordinator(store: .init(initialState: AppCoordinatorStateBuilder(sessionStorage: SessionStorage.shared).buildInitialState(),
                                        reducer: AppCoordinatorReducer()))
//            AppCoordinator(store: .init(initialState: .initialState, reducer: AppCoordinatorReducer(sessionStorage: .init(keychainStorage: .init()))))
//            SetBiometryView(
//                store: Store(
//                    initialState: SetBiometryStateBuilder(quickAccess: QuickAccess(
//                        sessionStorage: SessionStorage(keychainStorage: KeychainStorage())
//                    )).buildInitialState(),
//                    reducer: SetBiometryReducer(quickAccess: QuickAccess(sessionStorage: SessionStorage(keychainStorage: KeychainStorage())))
//                )
//            )
        }
    }

    init() {
        GMSServices.provideAPIKey("")
    }
}
