import API
import Dependencies
import DependenciesMacros
import GenericAPIClient

@DependencyClient public struct StartBracketAPIClient {

    public var start: (StartBracketRequest) async throws -> StartBracketResponse

}

extension DependencyValues {

    public var startBracketAPIClient: StartBracketAPIClient {
        get { self[StartBracketAPIClient.self] }
        set { self[StartBracketAPIClient.self] = newValue }
    }

}

extension StartBracketAPIClient: DependencyKey {

    public static var liveValue: StartBracketAPIClient {
        StartBracketAPIClient(
            start: { content in
                try await genericAPIClient.fetch(
                    route: .startBracket(content)
                )
            }
        )
    }

    public static var testValue = StartBracketAPIClient()

}
