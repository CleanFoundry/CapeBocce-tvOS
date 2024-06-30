import CFTuist
import ProjectDescription

let project = CFProject.capeBocce.toTuist()


//let project = Project(
//    name: "CapeBocce",
//    targets: [
//        .target(
//            name: "CapeBocce",
//            destinations: .tvOS,
//            product: .app,
//            bundleId: "io.tuist.CapeBocce",
//            infoPlist: .extendingDefault(
//                with: [
//                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
//                ]
//            ),
//            sources: ["CapeBocce/Sources/**"],
//            resources: ["CapeBocce/Resources/**"],
//            dependencies: [],
//            settings: .settings(base: [
//                "DEVELOPMENT_TEAM": "QHJFG75NY8",
//                "OTHER_LDFLAGS": "$(inherited) -ObjC",
//            ])
//        ),
//        .target(
//            name: "CapeBocceTests",
//            destinations: .tvOS,
//            product: .unitTests,
//            bundleId: "io.tuist.CapeBocceTests",
//            infoPlist: .default,
//            sources: ["CapeBocce/Tests/**"],
//            resources: [],
//            dependencies: [.target(name: "CapeBocce")]
//        ),
//    ]
//)
