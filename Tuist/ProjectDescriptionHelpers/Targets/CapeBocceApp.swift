import CFTuist
import ProjectDescription

public extension CFTarget.Name {
    static let capeBocceApp: Self = "CapeBocceApp"
}

public extension CFTarget {

    static let capeBocceApp = CFTarget.defaultApp(
        name: .capeBocceApp,
        destinations: [.tvOS],
        infoPlist: .extendingDefault([
            "UILaunchStoryboardName": "LaunchScreen.storyboard",
        ]),
        internalDependencies: [],
        externalDependencies: [],
        deploymentTarget: .tvOSDefault(),
        settings: [
            "DEVELOPMENT_TEAM": "QHJFG75NY8",
            "OTHER_LDFLAGS": "$(inherited) -ObjC",
        ]
    )

}
