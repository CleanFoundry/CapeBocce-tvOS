import CFTuist
import ProjectDescription

public extension CFProject {

    static let capeBocce = CFProject.default(
        name: "CapeBocce",
        targets: [
            .allBracketsFeatureKit,
            .allBracketsFeatureUI,
            .api,
            .apiExtensions,
            .bracketFeatureKit,
            .bracketFeatureUI,
            .championFeatureKit,
            .championFeatureUI,
            .capeBocceApp,
            .countryKit,
            .countryKitTests,
            .createBracketKit,
            .createBracketFormFeatureKit,
            .createBracketFormFeatureUI,
            .funFactDependency,
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
