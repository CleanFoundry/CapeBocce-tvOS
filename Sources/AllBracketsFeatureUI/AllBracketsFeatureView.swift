import AllBracketsFeatureKit
import ComposableArchitecture
import SwiftUI

public struct AllBracketsFeatureView: View {

    @Bindable var store: StoreOf<AllBracketsFeature>

    public init(store: StoreOf<AllBracketsFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("All brackets")
    }

}
