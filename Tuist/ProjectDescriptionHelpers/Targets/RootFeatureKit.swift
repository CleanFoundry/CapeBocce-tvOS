import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let rootFeatureKit: Self = "RootFeatureKit"
}

public extension CFTarget {

    static let rootFeatureKit = CFTarget.default.capeBocce.framework(
        name: .rootFeatureKit,
        internalDependencies: [
            .bracketModel,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

}
