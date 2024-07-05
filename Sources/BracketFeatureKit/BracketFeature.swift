import API
import ComposableArchitecture
import Tagged

@Reducer public struct BracketFeature {

    @ObservableState public struct State {

        public let bracketName: String
        private(set) public var groupedMatches: [MatchBracketSide: [Round: IdentifiedArrayOf<Match>]]

        public init(
            bracketName: String,
            groupedMatches: [MatchBracketSide: [Round: IdentifiedArrayOf<Match>]]
        ) {
            self.bracketName = bracketName
            self.groupedMatches = groupedMatches
        }

        public static func build(
            bracket: Bracket
        ) -> Self {
            .init(
                bracketName: bracket.name,
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

    public init() { }

}
