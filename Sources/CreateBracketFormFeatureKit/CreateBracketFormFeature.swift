import BracketModel
import ComposableArchitecture
import Foundation
import PickCountryFeatureKit

@Reducer public struct CreateBracketFormFeature {

    @ObservableState public struct State {

        public var bracketName: String
        public var selectedParticipants: IdentifiedArrayOf<Participant> = []

        public var addNewParticipantName: String = "Participant Name"

        @Presents public var pickCountry: PickCountryFeature.State?

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
        case submittedAddParticipant
        case pickCountry(PresentationAction<PickCountryFeature.Action>)
        case addedRecentParticipant(Participant)
        case removedParticipant(Participant)
        case tappedUpdateCountry(Participant)
        case tappedDeleteParticipant(Participant)
        case tappedAddAllRecentParticipants
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .submittedAddParticipant:
                state.pickCountry = .init(
                    title: "Choose Country for \(state.sanitizedAddParticipantName)"
                )
                return .none
            case let .tappedUpdateCountry(participant):
                state.pickCountry = .init(
                    title: "Update Country for \(participant.name)",
                    existingParticipant: participant
                )
                return .none
            case let .pickCountry(.presented(.selected(selectedCountry))):
                if let existingParticipant = state.pickCountry?.existingParticipant {

                    let updatedParticipant = Participant(
                        name: existingParticipant.name,
                        countryID: selectedCountry.id
                    )

                    if state.recentParticipants.contains(existingParticipant) {
                        state.recentParticipants[
                            id: existingParticipant.id
                        ]?.countryID = selectedCountry.id
                    } else {
                        state.recentParticipants.insert(updatedParticipant, at: 0)
                    }

                    if state.selectedParticipants.contains(existingParticipant) {
                        state.selectedParticipants[
                            id: existingParticipant.id
                        ]?.countryID = selectedCountry.id
                    } else {
                        state.selectedParticipants.insert(updatedParticipant, at: 0)
                    }
                } else {

                    let newParticipant = Participant(
                        name: state.sanitizedAddParticipantName,
                        countryID: selectedCountry.id
                    )

                    state.recentParticipants.insert(newParticipant, at: 0)
                    state.selectedParticipants.insert(newParticipant, at: 0)
                }

                state.pickCountry = nil
                return .none
            case let .addedRecentParticipant(participant):
                state.selectedParticipants.insert(participant, at: 0)
                return .none
            case let .removedParticipant(participant):
                state.selectedParticipants.remove(participant)
                return .none
            case let .tappedDeleteParticipant(participant):
                state.selectedParticipants.remove(participant)
                state.recentParticipants.remove(participant)
                return .none
            case .tappedAddAllRecentParticipants:
                state.selectedParticipants.append(
                    contentsOf: state.unselectedRecentParticipants
                )
                return .none
            case .binding,
                    .pickCountry:
                return .none
            }
        }
        .ifLet(
            \.$pickCountry,
             action: \.pickCountry,
             destination: PickCountryFeature.init
        )
    }

}
