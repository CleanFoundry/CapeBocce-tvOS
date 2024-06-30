import CFTuist
import ProjectDescription

public extension CFProject {

    static let capeBocce = CFProject.default(
        name: "CapeBocce",
        targets: [
            .apiClients,
            .bracketModel,
            .capeBocceApp,
            .countryKit,
            .countryKitTests,
            .createBracketFormFeatureKit,
            .createBracketFormFeatureUI,
            .genericAPIClient,
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
