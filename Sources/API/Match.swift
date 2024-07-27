import Foundation
import Tagged

public struct Match: Codable, Equatable, Identifiable {

    public let matchNumber: MatchNumber
    public var id: MatchNumber { matchNumber }

    public var participant1: MatchParticipant
    public var participant2: MatchParticipant
    public var winner: MatchWinner?

    public let heightScaleFactor: CGFloat

    public let kind: MatchKind
    public let side: MatchBracketSide
    public let round: Round

    public init(
        matchNumber: MatchNumber,
        participant1: MatchParticipant,
        participant2: MatchParticipant,
        winner: MatchWinner?,
        heightScaleFactor: CGFloat,
        kind: MatchKind,
        side: MatchBracketSide,
        round: Round
    ) {
        self.matchNumber = matchNumber
        self.participant1 = participant1
        self.participant2 = participant2
        self.winner = winner
        self.heightScaleFactor = heightScaleFactor
        self.kind = kind
        self.side = side
        self.round = round
    }

}

public enum MatchParticipant: Codable, Equatable {

    case participant(Participant)
    case awaitingWinner(MatchNumber)
    case awaitingLoser(MatchNumber)

}

public enum MatchKind: Codable, Equatable {

    case `default`
    public enum MatchChampionshipKind: String, Codable, Equatable {
        case overall
        case winners
        case losers
    }
    case championship(MatchChampionshipKind)

}

public enum MatchWinner: Codable, Equatable {
    case participant1
    case participant2
}

public enum MatchBracketSide: Codable, Equatable {
    case winners
    case losers
}
