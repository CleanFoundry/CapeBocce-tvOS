import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let rootFeatureKit: Self = "RootFeatureKit"
}

public extension CFTarget {

    static let rootFeatureKit = CFTarget.default.capeBocce.framework(
        name: .rootFeatureKit,
        internalDependencies: [
            .allBracketsFeatureKit,
            .api,
            .createBracketKit,
            .createBracketFormFeatureKit,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

    static let rootFeatureKitTests = CFTarget.default.capeBocce.frameworkUnitTests(
        testing: .rootFeatureKit,
        internalDependencies: [],
        externalDependencies: []
    )

}
