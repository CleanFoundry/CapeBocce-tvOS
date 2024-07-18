import API
import ChampionFeatureKit
import ComposableArchitecture
import Foundation
import Tagged

@Reducer public struct BracketFeature {

    @ObservableState public struct State {

        public let bracketName: String
        public let matches: IdentifiedArrayOf<Match>
        @Presents public var champion: ChampionFeature.State?
        private(set) public var groupedMatches: [MatchBracketSide: [Round: IdentifiedArrayOf<Match>]]
        public var showConfetti: Bool

        public init(
            bracketName: String,
            matches: IdentifiedArrayOf<Match>,
            groupedMatches: [MatchBracketSide: [Round: IdentifiedArrayOf<Match>]],
            champion: Participant?
        ) {
            self.bracketName = bracketName
            self.matches = matches
            self.groupedMatches = groupedMatches
            self.champion = champion.map(ChampionFeature.State.init)
            self.showConfetti = false
        }

        public static func build(
            bracket: Bracket
        ) -> Self {
            .init(
                bracketName: bracket.name,
                matches: bracket.matches,
                groupedMatches: bracket.matches.reduce(into: [:]) { partialResult, nextMatch in
                    partialResult[
                        nextMatch.side,
                        default: [:]
                    ][
                        nextMatch.round,
                        default: []
                    ].append(nextMatch)
                },
                champion: bracket.champion
            )
        }

    }

    public enum Action {
        case champion(PresentationAction<ChampionFeature.Action>)
        case didAppear
        case tappedParticipantWon(MatchWinner, Match, String)
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                state.showConfetti = state.champion != nil
                return .none
            case .tappedParticipantWon, .champion:
                return .none
            }
        }
        .ifLet(\.$champion, action: \.champion, destination: ChampionFeature.init)
    }

}
