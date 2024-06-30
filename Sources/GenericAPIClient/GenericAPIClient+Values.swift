import API
import CasePaths
import Foundation
import URLRouting

public let genericAPIRouter: some Router<EndpointRoute> = EndpointRouter.default
    .baseURL("http://Connors-21-Macbook-Pro.local:8080/")

public let genericAPIClient = GenericAPIClient(
    router: genericAPIRouter
)
