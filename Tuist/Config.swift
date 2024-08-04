import ProjectDescription

let config = Config(
    compatibleXcodeVersions: .exact(.init(16, 0, 0)),
    swiftVersion: .init(5, 9, 0),
    plugins: [
        .git(
            url: "https://github.com/CleanFoundry/cf-tuist-helpers.git",
            tag: Version(0, 0, 19).description
        )
    ]
)
