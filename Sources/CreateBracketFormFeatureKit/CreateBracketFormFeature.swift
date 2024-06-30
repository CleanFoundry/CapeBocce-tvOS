import BracketModel
import ComposableArchitecture
import Foundation
import PickCountryFeatureKit

@Reducer public struct CreateBracketFormFeature {

    @ObservableState public struct State {

        public var bracketName: String
        public var selectedParticipants: IdentifiedArrayOf<Participant> = []

        public var addNewParticipantName: String = "Participant Name"
        @Presents public var addNewParticipantPickCountry: PickCountryFeature.State?

        @Shared(.fileStorage(.recentParticipantsStorageURL))
        public var recentParticipants: IdentifiedArrayOf<Participant> = [
            Participant(name: "Connor", countryID: "US"),
            Participant(name: "Drake", countryID: "AE"),
            Participant(name: "Kelly", countryID: "DE"),
            Participant(name: "Liam", countryID: "CN"),
        ]

        public init(
            bracketName: String
        ) {
            self.bracketName = bracketName
        }

    }

    public enum Action: BindableAction {
        case binding(BindingAction<CreateBracketFormFeature.State>)
        case tappedAddParticipant
        case pickCountry(PresentationAction<PickCountryFeature.Action>)
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .tappedAddParticipant:
                state.addNewParticipantPickCountry = .init(
                    title: "Choose Country for \(state.sanitizedAddParticipantName)"
                )
                return .none
            case .binding, .pickCountry:
                return .none
            }
        }
        .ifLet(
            \.$addNewParticipantPickCountry,
             action: \.pickCountry,
             destination: PickCountryFeature.init
        )
    }

}
