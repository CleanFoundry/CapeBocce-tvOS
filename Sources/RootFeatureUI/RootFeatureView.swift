import ComposableArchitecture
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

                }
            }
            .navigationTitle("Cape Bocce")
        }
        .sheet(
            item: $store.scope(state: \.createBracket, action: \.createBracket)
        ) { foo in
            Text("Create")
        }
    }
}

//struct RootFeatureView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootFeatureView()
//    }
//}
