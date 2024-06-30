import ProjectDescription

let config = Config(
    compatibleXcodeVersions: .exact(.init(15, 3, 0)),
    swiftVersion: .init(5, 9, 0),
    plugins: [
        .git(
            url: "git@github.com:CleanFoundry/cf-tuist-helpers.git",
            tag: Version(0, 0, 13).description
        )
    ]
)
