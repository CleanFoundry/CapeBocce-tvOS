import API
import CasePaths
import Foundation
import URLRouting

@MainActor public let genericAPIRouter: some Router<EndpointRoute> = EndpointRouter.default
    .baseURL("https://slick-groups-search.loca.lt")

@MainActor public let genericAPIClient = GenericAPIClient(
    router: genericAPIRouter
)
