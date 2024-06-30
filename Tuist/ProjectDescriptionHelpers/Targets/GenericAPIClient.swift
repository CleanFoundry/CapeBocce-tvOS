import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let genericAPIClient: Self = "GenericAPIClient"
}

public extension CFTarget {

    static let genericAPIClient = CFTarget.default.capeBocce.framework(
        name: .genericAPIClient,
        internalDependencies: [
        ],
        externalDependencies: [
            .api,
            .urlRouting,
        ]
    )

}
