import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let bracketFeatureUI: Self = "BracketFeatureUI"
}

public extension CFTarget {

    static let bracketFeatureUI = CFTarget.default.capeBocce.framework(
        name: .bracketFeatureUI,
        internalDependencies: [
            .bracketFeatureKit,
            .championFeatureKit,
            .championFeatureUI,
            .countryKit,
        ],
        externalDependencies: [
            .api,
            .composableArchitecture,
            .confetti,
        ]
    )

}
