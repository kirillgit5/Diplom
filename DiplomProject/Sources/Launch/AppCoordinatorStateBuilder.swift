import Services

class AppCoordinatorStateBuilder {
    private let sessionStorage: SessionStorage

    init(sessionStorage: SessionStorage) {
        self.sessionStorage = sessionStorage
    }

    func buildInitialState() -> AppCoordinatorReducer.State {
//        sessionStorage.accessToken == nil ?
        .main(.initialState)
//        x/: .main(.initialState)
//            .login(.init(routes: [.root(.enterPhone(EnterPhoneStateBuilder(countriesListService: CountriesListService()).buildInitialState()))])) :

    }
}
