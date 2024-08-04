import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let appStoragePersistenceKit: Self = "AppStoragePersistenceKit"
}

public extension CFTarget {

    static let appStoragePersistenceKit = CFTarget.default.capeBocce.framework(
        name: .appStoragePersistenceKit,
        internalDependencies: [
            .api,
        ],
        externalDependencies: [
            .composableArchitecture,
        ]
    )

}
