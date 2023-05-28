public struct AccessTokenResponse: Decodable, Equatable {
    public let accessToken: String?
    public let refreshToken: String?

    private enum CodingKeys : String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
