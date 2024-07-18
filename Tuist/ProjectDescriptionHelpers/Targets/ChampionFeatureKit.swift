import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let championFeatureKit: Self = "ChampionFeatureKit"
}

public extension CFTarget {

    static let championFeatureKit = CFTarget.default.capeBocce.framework(
        name: .championFeatureKit,
        internalDependencies: [
            .countryKit,
        ],
        externalDependencies: [
            .api,
            .composableArchitecture,
        ]
    )

}
