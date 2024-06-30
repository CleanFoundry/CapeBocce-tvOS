import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let rootFeatureUI: Self = "RootFeatureUI"
}

public extension CFTarget {

    static let rootFeatureUI = CFTarget.default.capeBocce.framework(
        name: .rootFeatureUI,
        internalDependencies: [
            .rootFeatureKit,
        ],
        externalDependencies: []
    )

}
