import API
import CasePaths
import Foundation
import URLRouting

public let genericAPIRouter: some Router<EndpointRoute> = EndpointRouter.default
    .baseURL("https://petite-eagles-peel.loca.lt")

public let genericAPIClient = GenericAPIClient(
    router: genericAPIRouter
)
