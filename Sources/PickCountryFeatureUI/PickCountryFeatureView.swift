import ComposableArchitecture
import CountryKit
import PickCountryFeatureKit
import SwiftUI

public struct PickCountryFeatureView: View {

    @Bindable var store: StoreOf<PickCountryFeature>

    public init(store: StoreOf<PickCountryFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            List {
                ForEach(store.availableCountries) { country in
                    Button {
                        store.send(.selected(country))
                    } label: {
                        HStack(alignment: .center, spacing: 12) {
                            country.bundleAsset
                                .resizable()
                                .frame(width: 300, height: 150, alignment: .trailing)
                                .shadow(radius: 18)
                                .padding()
                            VStack(alignment: .leading) {
                                Text(country.name)
                                    .font(.title)
                            }
                        }
                    }
                }
            }
            .navigationTitle(store.title)
        }
        .searchable(text: $store.searchText)
    }

}
