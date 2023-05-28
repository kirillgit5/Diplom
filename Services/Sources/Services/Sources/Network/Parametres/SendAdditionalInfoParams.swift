import Foundation

public struct SendAdditionalInfoParams: Encodable {
    private let phone: String
    private let carInfo: String
    private let carNumber: String

    public init(
        phone: String,
        carInfo: String,
        carNumber: String
    ) {
        self.phone = phone
        self.carInfo = carInfo
        self.carNumber = carNumber
    }
}
