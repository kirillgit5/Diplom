public struct CheckRegistrationParams: Encodable {
    public let phone: String

    public init(phone: String) {
        self.phone = phone
    }
}
