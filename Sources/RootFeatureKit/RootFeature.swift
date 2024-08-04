import API
import AppStoragePersistenceKit
import ComposableArchitecture
import CountryKit
import CreateBracketFormFeatureKit
import CreateBracketKit
import Foundation

@Reducer public struct RootFeature {

    @ObservableState public struct State {

        @Presents public var destination: DestinationFeature.State?

        @Shared(.appStorage("recentParticipants")) private var recentParticipantsData: Data?
        public var recentParticipants: IdentifiedArrayOf<Participant> {
            get {
                guard let recentParticipantsData else { return [] }
                return try! JSONDecoder.api
                    .decode(IdentifiedArrayOf<Participant>.self, from: recentParticipantsData)
            } set {
                recentParticipantsData = try! JSONEncoder.api.encode(newValue)
            }
        }
        @Shared(.bracketsData) private var bracketsData: Data?
        public var brackets: IdentifiedArrayOf<Bracket> {
            get {
                guard let bracketsData else { return [] }
                return try! JSONDecoder.api
                    .decode(IdentifiedArrayOf<Bracket>.self, from: bracketsData)
            } set {
                bracketsData = try! JSONEncoder.api.encode(newValue)
            }
        }

        public init(
            destination: DestinationFeature.State? = nil
        ) {
            self.destination = destination
//            let testBracket = try! Bracket.generate(
//                name: "Crazy Bracket",
//                participants: Country.load().prefix(25).enumerated().map { offset, country in
//                    Participant(name: "Player \(offset)", countryID: country.id)
//                }
//            )
//            brackets.insert(testBracket, at: 0)
//            brackets = []
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
        Reduce {
            state,
            action in
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
