import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let apiExtensions: Self = "APIExtensions"
}

public extension CFTarget {

    static let apiExtensions = CFTarget.default.capeBocce.framework(
        name: .apiExtensions,
        internalDependencies: [
            .countryKit,
        ],
        externalDependencies: [
            .api,
        ]
    )

}
