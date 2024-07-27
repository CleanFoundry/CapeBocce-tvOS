import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let championFeatureUI: Self = "ChampionFeatureUI"
}

public extension CFTarget {

    static let championFeatureUI = CFTarget.default.capeBocce.framework(
        name: .championFeatureUI,
        internalDependencies: [
            .api,
            .championFeatureKit,
            .countryKit,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

}
