public struct RegistrationParams: Encodable {
    private let name: String
    private let surname: String
    private let email: String
    private let password: String
    private let birthDate: String
    private let phone: String

    public init(name: String, surname: String, email: String, password: String, birthDate: String, phone: String) {
        self.name = name
        self.surname = surname
        self.email = email
        self.password = password
        self.birthDate = birthDate
        self.phone = phone
    }

    private enum CodingKeys : String, CodingKey {
        case name
        case surname
        case email = "e-mail"
        case password
        case birthDate
        case phone
    }
}
