import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let funFactDependency: Self = "FunFactDependency"
}

public extension CFTarget {

    static let funFactDependency = CFTarget.default.capeBocce.framework(
        name: .funFactDependency,
        internalDependencies: [
        ],
        externalDependencies: [
            .api,
            .dependencies,
            .dependenciesMacros,
        ]
    )

}
