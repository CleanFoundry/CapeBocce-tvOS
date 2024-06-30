import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let countryKit: Self = "CountryKit"
}

public extension CFTarget {

    static let countryKit = CFTarget.default.capeBocce.framework(
        name: .countryKit,
        internalDependencies: [],
        externalDependencies: [],
        includeResources: true
    )

}
