import Dependencies
import DependenciesMacros

@DependencyClient public struct FunFactDependency {

    public var get: (_ countryName: String) async throws -> String

}

public extension DependencyValues {

    var funFact: FunFactDependency {
        get { self[FunFactDependency.self] }
        set { self[FunFactDependency.self] = newValue }
    }

}

extension FunFactDependency: DependencyKey {

    public static var liveValue: FunFactDependency {
        FunFactDependency(
            get: { _ in
                return "Ha ha"
            }
        )
    }

    public static var testValue = FunFactDependency()

}
