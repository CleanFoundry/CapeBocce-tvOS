import CFTuist
import ProjectDescription

public extension CFProject {

    static let capeBocce = CFProject.default(
        name: "CapeBocce",
        targets: [
            .bracketModel,
            .capeBocceApp,
            .rootFeatureKit,
            .rootFeatureUI,
        ],
        additionalFiles: []
    )

}
