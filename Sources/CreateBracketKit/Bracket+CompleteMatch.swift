import DataModel
import IdentifiedCollections

public extension Bracket {

    mutating func completeMatch(
        _ match: Match,
        winner matchWinner: MatchWinner
    ) {
        guard
            case let .participant(participant1) = match.participant1,
            case let .participant(participant2) = match.participant2 else {
            fatalError()
        }
        let (winner, loser): (Participant, Participant)
        switch matchWinner {
        case .participant1:
            (winner, loser) = (participant1, participant2)
        case .participant2:
            (winner, loser) = (participant2, participant1)
        }

        var updatedMatches: IdentifiedArrayOf<Match> = []
        for var nextMatch in matches {
            if nextMatch.matchNumber == match.matchNumber {
                nextMatch.winner = matchWinner
                if nextMatch.kind == .championship(.overall) {
                    self.champion = winner
                }
            } else if nextMatch.participant1 == .awaitingLoser(match.matchNumber) {
                nextMatch.participant1 = .participant(loser)
            } else if nextMatch.participant2 == .awaitingLoser(match.matchNumber) {
                nextMatch.participant2 = .participant(loser)
            } else if nextMatch.participant1 == .awaitingWinner(match.matchNumber) {
                nextMatch.participant1 = .participant(winner)
            } else if nextMatch.participant2 == .awaitingWinner(match.matchNumber) {
                nextMatch.participant2 = .participant(winner)
            }
            updatedMatches.append(nextMatch)
        }

        self.matches = updatedMatches
    }

}
