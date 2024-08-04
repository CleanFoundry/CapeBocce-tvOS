import DataModel
import AppStoragePersistenceKit
import CompleteMatchKit
import ComposableArchitecture
import CountryKit
import CreateBracketFormFeatureKit
import CreateBracketKit
import Foundation

@Reducer public struct RootFeature {

    @ObservableState public struct State: HasRecentParticipantsState, HasBracketsState {

        @Presents public var destination: DestinationFeature.State?

        @Shared(.recentParticipantsData) public var recentParticipantsData: Data?
        @Shared(.bracketsData) public var bracketsData: Data?

        public init(
            destination: DestinationFeature.State? = nil
        ) {
            self.destination = destination
        }

    }

    public enum Action {

        case tappedCreateBracket
        case tappedViewAllBrackets
        case startedBracket(Bracket)
        case destination(PresentationAction<DestinationFeature.Action>)

    }

    @Dependency(\.defaultBracketName) var defaultBracketName

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tappedCreateBracket:
                state.destination = .createBracket(.init(
                    bracketName: defaultBracketName.create()
                ))
                return .none
            case let .destination(.presented(.createBracket(
                .tappedStartBracket(participants, name)
            ))):
                let bracket = try! Bracket.generate(
                    name: name,
                    participants: participants
                )
                state.brackets.insert(bracket, at: 0)
                for participant in participants {
                    state.recentParticipants.updateOrInsert(participant, at: 0)
                }
                return .send(.startedBracket(bracket))
            case
                let .startedBracket(bracket),
                let .destination(.presented(.allBrackets(
                    .tappedBracket(bracket)
                ))):
                state.destination = .bracket(
                    .build(
                        bracket: bracket,
                        showChampion: false
                    )
                )
                return .none
            case .tappedViewAllBrackets:
                state.destination = .allBrackets(.init())
                return .none
            case let .destination(.presented(.bracket(
                .tappedParticipantWon(matchWinner, match, bracketName)
            ))):
                guard var bracket = state.brackets[id: bracketName] else {
                    fatalError()
                }
                bracket.completeMatch(match, winner: matchWinner)
                state.destination = .bracket(.build(bracket: bracket, showChampion: true))
                state.brackets[id: bracketName] = bracket
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(
            \.$destination,
             action: \.destination
        )
    }

}
