// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [:]
    )
#endif

let package = Package(
    name: "CapeBocce",
    dependencies: [
        // MARK: - PointFree
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: .init(1, 11, 2)),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: .init(1, 3, 1)),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: .init(1, 16, 1)),
        .package(url: "https://github.com/pointfreeco/swift-tagged", from: .init(0, 10, 0)),
    ]
)
