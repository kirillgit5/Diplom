import Core
import UIKit
import PhoneNumberKit

public protocol CountriesListSevriceAbstract {
    func countriesList() -> [Country]
    func prefferedCountry() -> Country
}

public final class CountriesListService: CountriesListSevriceAbstract {
    public init() { }

    public func countriesList() -> [Country] {
        parseCountriesFile()
    }

    public func countriesList(sorted: CountriesSortType) -> [Country] {
        countriesList().sorted(by: { $0.localizedName.localizedCaseInsensitiveCompare($1.localizedName) == .orderedAscending })
    }

    public func prefferedCountry() -> Country {
        let region = PhoneNumberKit.defaultRegionCode()
        let countriesList = parseCountriesFile()

        guard let prefferedCountry = countriesList.first(where: { $0.countryCode.uppercased() == region.uppercased() })
        else {
            return Country(
                countryCode: "RU",
                phoneCode: "+7",
                flagImage: flag(for: "RU"),
                phoneMask: "XXX XXX XXXX",
                localizedName: localizedName(for: "RU")
            )
        }
        return prefferedCountry
    }

    private func parseCountriesFile() -> [Country] {
        guard let path = Bundle.main.path(
            forResource: Constant.countriesFileName,
            ofType: Constant.countriesFileExt
        )
        else { return [] }
        do {
            guard let data = try String(contentsOfFile: path).data(using: .utf8) else { return [] }
            let decodedData = try JSONDecoder().decode([CountryResponse].self, from: data)
            let countries = decodedData.map {
                Country(
                    countryCode: $0.countryCode,
                    phoneCode: $0.code,
                    flagImage: flag(for: $0.countryCode),
                    phoneMask: $0.phoneMask,
                    localizedName: localizedName(for: $0.countryCode)
                )
            }
            return countries
        } catch {
            return []
        }
    }
}

private extension CountriesListService {
    func flag(for countryCode: String) -> UIImage {
        UIImage(named: countryCode.lowercased(), in: Bundle(for: Self.self), with: nil)!
    }

    func localizedName(for countryCode: String) -> String {
        Locale.current.localizedString(forRegionCode: countryCode) ?? ""
    }
}

public extension CountriesListService {
    enum CountriesSortType {
        case byName
    }

    private enum Constant {
        static let countriesFileName = "countries_list"
        static let countriesFileExt = "json"
    }
}

private extension CountriesListService {
    struct CountryResponse: Decodable {
        let code: String
        let countryCode: String
        let countryName: String
        let phoneMask: String
    }
}
