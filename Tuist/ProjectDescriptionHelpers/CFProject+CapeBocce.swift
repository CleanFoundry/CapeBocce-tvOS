import CFTuist
import ProjectDescription

public extension CFProject {

    static let capeBocce = CFProject.default(
        name: "CapeBocce",
        targets: [
            .capeBocceApp,
            .rootFeatureKit,
            .rootFeatureUI,
        ],
        additionalFiles: []
    )

}