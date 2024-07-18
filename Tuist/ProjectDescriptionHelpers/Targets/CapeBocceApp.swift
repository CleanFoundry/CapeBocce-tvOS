import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let capeBocceApp: Self = "CapeBocceApp"
}

public extension CFTarget {

    static let capeBocceApp = CFTarget.default.capeBocce.app(
        name: .capeBocceApp,
        productName: "Cape Bocce",
        internalDependencies: [
            .rootFeatureKit,
            .rootFeatureUI,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

}
