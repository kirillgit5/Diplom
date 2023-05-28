public struct AccessTokenParams: Encodable {
    private let number: String
    private let password: String
    private let grant_type = "password"
    private let client_id = "companion"

    public init(number: String, password: String) {
        self.number = number
        self.password = password
    }
}
