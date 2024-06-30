import ComposableArchitecture
import RootFeatureKit
import SwiftUI

public struct CreateBracketFormFeatureView: View {

    @Bindable var store: StoreOf<CreateBracketFormFeature>

    public init(store: StoreOf<CreateBracketFormFeature>) {
        self.store = store
    }

    public var body: some View {
        Form {
            Text("Hi")
        }
    }
}
