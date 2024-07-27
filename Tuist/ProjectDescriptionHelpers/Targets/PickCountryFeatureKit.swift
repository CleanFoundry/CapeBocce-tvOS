import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let pickCountryFeatureKit: Self = "PickCountryFeatureKit"
}

public extension CFTarget {

    static let pickCountryFeatureKit = CFTarget.default.capeBocce.framework(
        name: .pickCountryFeatureKit,
        internalDependencies: [
            .api,
            .apiExtensions,
            .countryKit,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

}
