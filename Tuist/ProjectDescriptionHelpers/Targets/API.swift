import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let api: Self = "API"
}

public extension CFTarget {

    static let api = CFTarget.default.capeBocce.framework(
        name: .api,
        internalDependencies: [
            .countryKit,
        ],
        externalDependencies: [
            .identifiedCollections,
            .tagged,
        ]
    )

}
