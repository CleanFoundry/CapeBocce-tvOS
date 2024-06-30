import BracketModel
import ComposableArchitecture
import CountryKit

@Reducer public struct PickCountryFeature {

    @ObservableState public struct State {

        public let title: String
        public let existingParticipant: Participant?
        public var searchText: String = ""

        public var availableCountries: [Country] {
            Country.load()
                .filter { country in
                    country.name.lowercased()
                        .hasPrefix(searchText.lowercased())
                }
        }

        public init(
            title: String,
            existingParticipant: Participant? = nil
        ) {
            self.title = title
            self.existingParticipant = existingParticipant
        }

    }

    public enum Action: BindableAction {
        case selected(Country)
        case binding(BindingAction<PickCountryFeature.State>)
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        BindingReducer()
    }

}
