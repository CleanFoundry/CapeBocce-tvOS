import BracketFeatureKit
import ComposableArchitecture
import SwiftUI

public struct BracketFeatureView: View {

    @Bindable var store: StoreOf<BracketFeature>

    public init(store: StoreOf<BracketFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
//                if let winnersMatches = store.groupedMatches[.winners] {
//                    Section("Winners Bracket") {
//                        ForEach(winnersMatches) { <#Identifiable#> in
//                            <#code#>
//                        }
//
//                        Button { } label: {
//                            RoundedRectangle(cornerRadius: 24)
//                                .frame(width: 600, height: 240)
//                                .background(.blue)
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//
//                }
            }
            .navigationTitle(store.bracketName)
        }
    }

}
