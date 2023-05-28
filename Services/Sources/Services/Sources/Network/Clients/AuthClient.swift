import ComposableArchitecture
import Foundation
import Core

public struct AuthClient {
    public func registration(with params: RegistrationParams) async throws -> Int {
        var request = URLRequest(
            url: URL(string: Environment.prod.server.baseUrl(for: .registration) + "registration/")!,
            cachePolicy: .reloadIgnoringLocalCacheData
            )

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary(forObject: params), options: [])

        let (_, response) = try await URLSession.shared.data(for: request)

        return (response as? HTTPURLResponse)?.statusCode ?? 400
    }

    public func checkRegistration(with params: CheckRegistrationParams) async throws -> Int {
        var request = URLRequest(
            url: URL(string: Environment.prod.server.baseUrl(for: .check) + "check/")!,
            cachePolicy: .reloadIgnoringLocalCacheData
            )

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary(forObject: params), options: [])

        let (_, response) = try await URLSession.shared.data(for: request)

        return (response as? HTTPURLResponse)?.statusCode ?? 400
    }

    public func auth(with params: AccessTokenParams) async throws -> AccessTokenResponse {
        var request = URLRequest(
            url: URL(string: Environment.prod.server.baseUrl(for: .refresh) + "registration/")!,
            cachePolicy: .reloadIgnoringLocalCacheData
            )

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary(forObject: params), options: [])

        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(AccessTokenResponse.self, from: data)
    }


    public init() {}
}

func dictionary<T: Encodable>(forObject object: T?) throws -> [String: Any]? {
    guard let object = object else {
        return nil
    }

    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(object)
    let dictionary = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
    return dictionary
}
