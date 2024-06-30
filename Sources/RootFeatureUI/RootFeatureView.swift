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

                }
                Button("View All Brackets") {

                }
            }
            .navigationTitle("Cape Bocce")
        }
    }
}

//struct RootFeatureView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootFeatureView()
//    }
//}
