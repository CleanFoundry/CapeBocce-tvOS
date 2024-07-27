import API
import ChampionFeatureKit
import ComposableArchitecture
import Foundation
import Tagged

@Reducer public struct BracketFeature {

    @ObservableState public struct State {

        public let bracketName: Bracket.Name
        public let matches: IdentifiedArrayOf<Match>
        public let initialChampion: Participant?
        @Presents public var champion: ChampionFeature.State?
        private(set) public var groupedMatches: [MatchBracketSide: [Round: IdentifiedArrayOf<Match>]]
        public var showConfetti: Bool

        public init(
            bracketName: Bracket.Name,
            matches: IdentifiedArrayOf<Match>,
            groupedMatches: [MatchBracketSide: [Round: IdentifiedArrayOf<Match>]],
            initialChampion: Participant?,
            champion: ChampionFeature.State?
        ) {
            self.bracketName = bracketName
            self.matches = matches
            self.groupedMatches = groupedMatches
            self.initialChampion = initialChampion
            self.champion = champion
            self.showConfetti = false
        }

        public static func build(
            bracket: Bracket,
            showChampion: Bool
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
                initialChampion: bracket.champion,
                champion: showChampion ? bracket.champion.map(ChampionFeature.State.init) : nil
            )
        }

    }

    public enum Action {
        case champion(PresentationAction<ChampionFeature.Action>)
        case didAppear
        case tappedParticipantWon(MatchWinner, Match, Bracket.Name)
        case tappedChampion
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                state.showConfetti = state.champion != nil
                return .none
            case .tappedChampion:
                state.champion = state.initialChampion.map(ChampionFeature.State.init)
                return .none
            case .tappedParticipantWon, .champion:
                return .none
            }
        }
        .ifLet(\.$champion, action: \.champion, destination: ChampionFeature.init)
    }

}
