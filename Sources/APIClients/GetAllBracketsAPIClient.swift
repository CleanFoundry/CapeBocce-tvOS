import API
import Dependencies
import DependenciesMacros
import Foundation
import GenericAPIClient
import IdentifiedCollections

@DependencyClient public struct GetAllBracketsAPIClient {

    public var get: () async throws -> GetAllBracketsResponse

}

extension DependencyValues {

    public var getAllBracketsAPIClient: GetAllBracketsAPIClient {
        get { self[GetAllBracketsAPIClient.self] }
        set { self[GetAllBracketsAPIClient.self] = newValue }
    }

}

extension GetAllBracketsAPIClient: DependencyKey {

    public static var liveValue: GetAllBracketsAPIClient {
        GetAllBracketsAPIClient(
            get: {
//                let json = """
//[{"createdAt":"2024-07-05T14:00:18Z","matches":[{"kind":{"default":{}},"matchNumber":1,"participant1":{"participant":{"_0":{"countryID":"LA","name":"Liam"}}},"participant2":{"participant":{"_0":{"countryID":"MT","name":"Jan"}}},"round":0,"side":{"winners":{}}},{"kind":{"default":{}},"matchNumber":3,"participant1":{"participant":{"_0":{"countryID":"DO","name":"Liz"}}},"participant2":{"participant":{"_0":{"countryID":"PA","name":"Kelly"}}},"round":1,"side":{"winners":{}}},{"kind":{"default":{}},"matchNumber":4,"participant1":{"participant":{"_0":{"countryID":"FJ","name":"Drake"}}},"participant2":{"participant":{"_0":{"countryID":"SC","name":"Cody"}}},"round":1,"side":{"winners":{}}},{"kind":{"default":{}},"matchNumber":5,"participant1":{"participant":{"_0":{"countryID":"IN","name":"Connor"}}},"participant2":{"participant":{"_0":{"countryID":"GE","name":"Joe"}}},"round":1,"side":{"winners":{}}}],"name":"7/5/24"}]
//
//"""
//                return .init(
//                    brackets: try JSONDecoder.api.decode(
//                        IdentifiedArrayOf<Bracket>.self,
//                        from: json.data(using: .utf8)!
//                    )
//                )
                return try await genericAPIClient.fetch(route: .getAllBrackets)
            }
        )
    }

    public static var testValue = GetAllBracketsAPIClient()

}
