import AllBracketsFeatureKit
import ComposableArchitecture
import SwiftUI

public struct AllBracketsFeatureView: View {

    @Bindable var store: StoreOf<AllBracketsFeature>

    public init(store: StoreOf<AllBracketsFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            List(store.brackets) { bracket in
                Button(bracket.name) {
                    store.send(.tappedBracket(bracket))
                }
            }
            .navigationTitle("All Brackets (\(store.brackets.count))")
        }
    }

}
