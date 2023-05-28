import Services

struct EnterPhoneStateBuilder {

    private let countriesListService: CountriesListSevriceAbstract

    init(countriesListService: CountriesListSevriceAbstract) {
        self.countriesListService = countriesListService
    }

    func buildInitialState() -> EnterPhoneReducer.State {
        .init(
            country: countriesListService.prefferedCountry(),
            phoneNumber: "",
            isSendButtonEnabled: false,
            isKeyboardActive: true,
            isCountySelect: false,
            viewState: .pending,
            availableCountries: countriesListService.countriesList()
        )
    }
}
