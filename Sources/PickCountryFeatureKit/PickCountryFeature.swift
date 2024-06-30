import ComposableArchitecture
import CountryKit

@Reducer public struct PickCountryFeature {

    @ObservableState public struct State {

        public let title: String
        public var searchText: String = ""

        public var availableCountries: [Country] {
            Country.load()
                .filter { country in
                    country.name.lowercased()
                        .hasPrefix(searchText.lowercased())
                }
        }

        public init(
            title: String
        ) {
            self.title = title
        }

    }

    public enum Action: BindableAction {
        case binding(BindingAction<PickCountryFeature.State>)
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        BindingReducer()
    }

}
