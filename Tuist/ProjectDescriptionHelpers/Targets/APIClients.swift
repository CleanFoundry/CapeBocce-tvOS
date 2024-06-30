import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let apiClients: Self = "APIClients"
}

public extension CFTarget {

    static let apiClients = CFTarget.default.capeBocce.framework(
        name: .apiClients,
        internalDependencies: [
            .genericAPIClient,
        ],
        externalDependencies: [
            .api,
            .dependencies,
            .dependenciesMacros,
        ]
    )

}
