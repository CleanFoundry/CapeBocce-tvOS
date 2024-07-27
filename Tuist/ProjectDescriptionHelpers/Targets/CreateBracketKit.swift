import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let createBracketKit: Self = "CreateBracketKit"
}

public extension CFTarget {

    static let createBracketKit = CFTarget.default.capeBocce.framework(
        name: .createBracketKit,
        internalDependencies: [
            .api,
        ],
        externalDependencies: [
        ]
    )

}
