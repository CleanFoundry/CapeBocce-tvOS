import CFTuist
import ProjectDescription

public extension CFProject {

    static let capeBocce = CFProject.default(
        name: "CapeBocce",
        targets: [
            .allBracketsFeatureKit,
            .allBracketsFeatureUI,
            .apiExtensions,
            .bracketFeatureKit,
            .bracketFeatureUI,
            .capeBocceApp,
            .countryKit,
            .countryKitTests,
            .createBracketKit,
            .createBracketFormFeatureKit,
            .createBracketFormFeatureUI,
            .pickCountryFeatureKit,
            .pickCountryFeatureUI,
            .rootFeatureKit,
            .rootFeatureKitTests,
            .rootFeatureUI,
            .rootFeatureUITests,
        ],
        additionalFiles: []
    )

}
