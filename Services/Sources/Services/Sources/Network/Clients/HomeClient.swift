import ComposableArchitecture
import Foundation
import Core

public struct HomeClient {

    public init() {}

    public func checkDriverExist(with params: CheckDriverExistParams) async throws -> Int {
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

    public func sendAdditionalInfo(with params: SendAdditionalInfoParams) async throws -> Int {
        var request = URLRequest(
            url: URL(string: Environment.prod.server.baseUrl(for: .check) + "registration/update")!,
            cachePolicy: .reloadIgnoringLocalCacheData
            )

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary(forObject: params), options: [])

        let (_, response) = try await URLSession.shared.data(for: request)

        return (response as? HTTPURLResponse)?.statusCode ?? 400
    }

    public func getGeocodeLocation(address: String) async throws -> GeocodeLocationResponse {
        var url = URLComponents(string: Environment.prod.server.baseUrl(for: .geocode) + "geocode/json")!
        url.queryItems = [
            URLQueryItem(name: "address", value: address),
            URLQueryItem(name: "key", value: "")
        ]
        var request = URLRequest(
            url: url.url!
        )

        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(GeocodeLocationResponse.self, from: data)
    }

    public func direction(destination: String, origin: String) async throws -> DirectionResponse {
        var url = URLComponents(string: Environment.prod.server.baseUrl(for: .geocode) + "directions/json")!

        url.queryItems = [
            URLQueryItem(name: "destination", value: destination),
            URLQueryItem(name: "key", value: ""),
            URLQueryItem(name: "origin", value: origin)
        ]

        var request = URLRequest(
            url: url.url!
        )

        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(DirectionResponse.self, from: data)
    }

    public func postCompanionFind(params: CompanionFindParams) async throws -> [CompanionFindResponse] {
        var request = URLRequest(
            url: URL(string: Environment.prod.server.baseUrl(for: .companion) + "companion/find/")!,
            cachePolicy: .reloadIgnoringLocalCacheData
        )

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary(forObject: params), options: [])

        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode([CompanionFindResponse].self, from: data)
    }

    public func postCreateDriver(params: CreateDriverParams) async throws -> String {
        var request = URLRequest(
            url: URL(string: Environment.prod.server.baseUrl(for: .driver) + "companion/createDrive/")!,
            cachePolicy: .reloadIgnoringLocalCacheData
        )

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(String.self, from: data)
    }
}
