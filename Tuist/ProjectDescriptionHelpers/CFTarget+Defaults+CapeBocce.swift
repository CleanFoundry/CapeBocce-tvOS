import CFTuist
import ProjectDescription

public extension CFTarget.Default {

    struct CapeBocce {
        fileprivate init() { }
    }
    var capeBocce: CapeBocce { .init() }

}

public extension CFTarget.Default.CapeBocce {

    func app(
        name: CFTarget.Name,
        internalDependencies: [CFTarget.Name],
        externalDependencies: [CFExternalTargetName]
    ) -> CFTarget {
        .default.app(
            name: name,
            destinations: [.tvOS],
            infoPlist: .extendingDefault([
                "UILaunchStoryboardName": "LaunchScreen.storyboard",
            ]),
            internalDependencies: internalDependencies,
            externalDependencies: externalDependencies,
            deploymentTarget: .tvOSDefault(),
            settings: [
                "DEVELOPMENT_TEAM": "QHJFG75NY8",
                "OTHER_LDFLAGS": "$(inherited) -ObjC",
            ]
        )
    }

    func framework(
        name: CFTarget.Name,
        internalDependencies: [CFTarget.Name],
        externalDependencies: [CFExternalTargetName],
        includeResources: Bool = false
    ) -> CFTarget {
        .default.framework(
            name: name,
            destinations: [.tvOS],
            internalDependencies: internalDependencies,
            externalDependencies: externalDependencies,
            deploymentTarget: .tvOSDefault(),
            includeResources: includeResources
        )
    }


}
