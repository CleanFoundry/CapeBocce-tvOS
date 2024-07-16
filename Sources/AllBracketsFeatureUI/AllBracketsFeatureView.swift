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
            ScrollView {
                ForEach(store.brackets) { bracket in
                    HStack {
                        Button(bracket.name) {
                            store.send(.tappedBracket(bracket))
                        }
                        .tint(nil)
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        Button(role: .destructive) {
                            store.send(.tappedDeleteBracket(bracket))
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
                .padding(.top)
            }
            .scrollClipDisabled()
            .alert($store.scope(state: \.alert, action: \.alert))
            .navigationTitle("All Brackets (\(store.brackets.count))")
        }
    }

}
