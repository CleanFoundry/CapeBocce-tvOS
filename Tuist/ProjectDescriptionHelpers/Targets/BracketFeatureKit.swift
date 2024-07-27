import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let bracketFeatureKit: Self = "BracketFeatureKit"
}

public extension CFTarget {

    static let bracketFeatureKit = CFTarget.default.capeBocce.framework(
        name: .bracketFeatureKit,
        internalDependencies: [
            .api,
            .championFeatureKit,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

}
