import API
import Dependencies
import DependenciesMacros
import GenericAPIClient

@DependencyClient public struct GetRecentParticipantsAPIClient {

    public var get: () async throws -> GetRecentParticipantsResponse

}

extension DependencyValues {

    public var getRecentParticipantsAPIClient: GetRecentParticipantsAPIClient {
        get { self[GetRecentParticipantsAPIClient.self] }
        set { self[GetRecentParticipantsAPIClient.self] = newValue }
    }

}

extension GetRecentParticipantsAPIClient: DependencyKey {

    public static var liveValue: GetRecentParticipantsAPIClient {
        GetRecentParticipantsAPIClient(
            get: {
                try await genericAPIClient.fetch(
                    route: .getRecentParticipants
                )
            }
        )
    }

    public static var testValue = GetRecentParticipantsAPIClient()

}
