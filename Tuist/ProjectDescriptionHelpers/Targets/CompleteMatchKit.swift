import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let completeMatchKit: Self = "CompleteMatchKit"
}

public extension CFTarget {

    static let completeMatchKit = CFTarget.default.capeBocce.framework(
        name: .completeMatchKit,
        internalDependencies: [
            .dataModel,
        ],
        externalDependencies: [
            .identifiedCollections,
        ]
    )

}
