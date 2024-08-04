import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let dataModel: Self = "DataModel"
}

public extension CFTarget {

    static let dataModel = CFTarget.default.capeBocce.framework(
        name: .dataModel,
        internalDependencies: [
            .countryKit,
        ],
        externalDependencies: [
            .identifiedCollections,
            .tagged,
        ]
    )

}
