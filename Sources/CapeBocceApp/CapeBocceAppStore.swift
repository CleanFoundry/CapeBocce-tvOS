import ComposableArchitecture
import RootFeatureKit

struct CapeBocceAppStore {

    let store = Store(
        initialState: .init(
            createBracketForm: .init(name: "Test Name")
        ),
        reducer: {
            RootFeature()
                ._printChanges()
        }
    )
//    { dependencies in
//    }

    private init() { }

    static let shared = CapeBocceAppStore()

}
