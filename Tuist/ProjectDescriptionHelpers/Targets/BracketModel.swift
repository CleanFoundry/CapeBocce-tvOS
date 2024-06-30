import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let bracketModel: Self = "BracketModel"
}

public extension CFTarget {

    static let bracketModel = CFTarget.default.capeBocce.framework(
        name: .bracketModel,
        internalDependencies: [
            .countryKit,
        ],
        externalDependencies: []
    )

}
