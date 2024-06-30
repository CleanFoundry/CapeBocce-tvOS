import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let createBracketFormFeatureUI: Self = "CreateBracketFormFeatureUI"
}

public extension CFTarget {

    static let createBracketFormFeatureUI = CFTarget.default.capeBocce.framework(
        name: .createBracketFormFeatureUI,
        internalDependencies: [
            .createBracketFormFeatureKit,
            .pickCountryFeatureKit,
            .pickCountryFeatureUI,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

}
