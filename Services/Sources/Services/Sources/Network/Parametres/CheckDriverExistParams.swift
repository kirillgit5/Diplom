import Foundation

public struct CheckDriverExistParams: Encodable {
    private let phone: String

    public init(phone: String) {
        self.phone = phone
    }
}
