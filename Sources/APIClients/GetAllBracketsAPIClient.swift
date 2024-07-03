import API
import Dependencies
import DependenciesMacros
import GenericAPIClient

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
                try await genericAPIClient.fetch(
                    route: .getAllBrackets
                )
            }
        )
    }

    public static var testValue = GetAllBracketsAPIClient()

}
