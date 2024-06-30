import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let rootFeatureUI: Self = "RootFeatureUI"
}

public extension CFTarget {

    static let rootFeatureUI = CFTarget.default.capeBocce.framework(
        name: .rootFeatureUI,
        internalDependencies: [
            .createBracketFormFeatureKit,
            .createBracketFormFeatureUI,
            .rootFeatureKit,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

    static let rootFeatureUITests = CFTarget.default.capeBocce.frameworkUnitTests(
        testing: .rootFeatureUI,
        internalDependencies: [
            .rootFeatureKit
        ],
        externalDependencies: [
            .snapshotTesting
        ]
    )

}
