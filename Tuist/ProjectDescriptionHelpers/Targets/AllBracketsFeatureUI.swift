import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let allBracketsFeatureUI: Self = "AllBracketsFeatureUI"
}

public extension CFTarget {

    static let allBracketsFeatureUI = CFTarget.default.capeBocce.framework(
        name: .allBracketsFeatureUI,
        internalDependencies: [
            .allBracketsFeatureKit,
        ],
        externalDependencies: [
            .api,
            .composableArchitecture,
        ]
    )

}
