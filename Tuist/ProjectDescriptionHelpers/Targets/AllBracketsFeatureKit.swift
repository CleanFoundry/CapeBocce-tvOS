import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let allBracketsFeatureKit: Self = "AllBracketsFeatureKit"
}

public extension CFTarget {

    static let allBracketsFeatureKit = CFTarget.default.capeBocce.framework(
        name: .allBracketsFeatureKit,
        internalDependencies: [
            .api,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

}
