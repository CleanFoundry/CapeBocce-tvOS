import API
import ComposableArchitecture
import Foundation
import Tagged

@Reducer public struct BracketFeature {

    @ObservableState public struct State {

        public let bracketName: String
        public let matches: IdentifiedArrayOf<Match>
        private(set) public var groupedMatches: [MatchBracketSide: [Round: IdentifiedArrayOf<Match>]]

        public init(
            bracketName: String,
            matches: IdentifiedArrayOf<Match>,
            groupedMatches: [MatchBracketSide: [Round: IdentifiedArrayOf<Match>]]
        ) {
            self.bracketName = bracketName
            self.matches = matches
            self.groupedMatches = groupedMatches
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
                }
            )
        }

    }

    public enum Action {
        case tappedParticipantWon(MatchWinner, Match, String)
    }

    public init() { }

}
