import ComposableArchitecture
import PickCountryFeatureKit
import SwiftUI

public struct PickCountryFeatureView: View {

    @Bindable var store: StoreOf<PickCountryFeature>

    public init(store: StoreOf<PickCountryFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            Form {

            }
            .navigationTitle(store.title)
        }
    }

}
