import UIKit

public struct Country: Equatable {
    public let countryCode: String
    public let phoneCode: String
    public let flagImage: UIImage
    public let phoneMask: String
    public let localizedName: String

    public init(
        countryCode: String,
        phoneCode: String,
        flagImage: UIImage,
        phoneMask: String,
        localizedName: String
    ) {
        self.countryCode = countryCode
        self.phoneCode = phoneCode
        self.flagImage = flagImage
        self.phoneMask = phoneMask
        self.localizedName = localizedName
    }
}
