import API
import Foundation
import URLRouting

public final class GenericAPIClient<Route> {

    public let router: any Router<Route>
    public struct DebugOptions {

        public let artificialSleep: ((Route) -> Int?)?

        public init(
            artificialSleep: ((Route) -> Int?)? = nil
        ) {
            self.artificialSleep = artificialSleep
        }

    }
    public let debugOptions: DebugOptions?

    public init(
        router: any Router<Route>,
        debugOptions: DebugOptions? = nil
    ) {
        self.router = router
        self.debugOptions = debugOptions
    }

}

public extension GenericAPIClient {

    func fetch<Response: Decodable>(route: Route) async throws -> Response {
        try await maybeArtificialSleep(route: route)

        let data = try await URLSession.shared
            .data(for: router.request(for: route)).0
        return try JSONDecoder.api.decode(Response.self, from: data)
    }

}

private extension GenericAPIClient {

    func maybeArtificialSleep(route: Route) async throws {
        if let duration = debugOptions?.artificialSleep?(route) {
            try await Task.sleep(for: Duration.seconds(duration))
        }
    }

}
