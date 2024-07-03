import BracketFeatureUI
import ComposableArchitecture
import CreateBracketFormFeatureUI
import RootFeatureKit
import SwiftUI

public struct RootFeatureView: View {

    @Bindable var store: StoreOf<RootFeature>

    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            VStack {
                Button("Create Bracket") {
                    store.send(.tappedCreateBracket)
                }
                Button("View All Brackets") {
                    store.send(.tappedViewAllBrackets)
                }
            }
            .navigationTitle("Cape Bocce")
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.createBracket,
                action: \.destination.createBracket
            )
        ) { store in
            CreateBracketFormFeatureView(store: store)
        }
        .fullScreenCover(
            item: $store.scope(state: \.destination?.bracket, action: \.destination.bracket)
        ) { store in
            BracketFeatureView(store: store)
        }
    }
}
