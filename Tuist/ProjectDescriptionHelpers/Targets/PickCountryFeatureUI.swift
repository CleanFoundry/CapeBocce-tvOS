import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let pickCountryFeatureUI: Self = "PickCountryFeatureUI"
}

public extension CFTarget {

    static let pickCountryFeatureUI = CFTarget.default.capeBocce.framework(
        name: .pickCountryFeatureUI,
        internalDependencies: [
            .countryKit,
            .pickCountryFeatureKit,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

}
