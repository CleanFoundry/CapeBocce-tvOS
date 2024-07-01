import API
import CasePaths
import Foundation
import URLRouting

public let genericAPIRouter: some Router<EndpointRoute> = EndpointRouter.default
    .baseURL("https://silent-dolls-enjoy.loca.lt/")

public let genericAPIClient = GenericAPIClient(
    router: genericAPIRouter
)
