import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let createBracketFormFeatureKit: Self = "CreateBracketFormFeatureKit"
}

public extension CFTarget {

    static let createBracketFormFeatureKit = CFTarget.default.capeBocce.framework(
        name: .createBracketFormFeatureKit,
        internalDependencies: [
            .api,
            .appStoragePersistenceKit,
            .pickCountryFeatureKit,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

}
