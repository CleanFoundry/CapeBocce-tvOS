import API
import Foundation

public extension Bracket {

    static func generate(
        name: String,
        participants: [Participant]
    ) throws -> Self {
        let basicInfo = generateBasicInfo(participants: participants)

        let winnerFillingRoundInfo = generateWinnerFillingRoundInfo(
            basicInfo: basicInfo,
            participants: participants
        )

        let winnerFirstFilledRoundInfo = generateWinnerFirstFilledRoundInfo(
            basicInfo: basicInfo,
            winnerFillingRoundInfo: winnerFillingRoundInfo,
            participants: participants
        )

        let loserInitialRoundsInfo = generateLoserInitialRoundsInfo(
            winnerFillingRoundInfo: winnerFillingRoundInfo,
            winnerFirstFilledRoundInfo: winnerFirstFilledRoundInfo
        )

        let loserFillingRoundInfo = generateLoserFillingRoundInfo(
            loserInitialRoundsInfo: loserInitialRoundsInfo,
            winnerFillingRoundInfo: winnerFillingRoundInfo,
            winnerFirstFilledRoundInfo: winnerFirstFilledRoundInfo
        )

        let loserFirstFilledRoundInfo = generateLoserFirstFilledRoundInfo(
            loserInitialRoundsInfo: loserInitialRoundsInfo,
            loserFillingRoundInfo: loserFillingRoundInfo,
            winnerFillingRoundInfo: winnerFillingRoundInfo,
            winnerFirstFilledRoundInfo: winnerFirstFilledRoundInfo,
            participants: participants
        )

        let winnerRecursiveRoundsInfo = generateWinnerRecursiveRoundsInfo(
            winnerFirstFilledRoundInfo: winnerFirstFilledRoundInfo,
            loserFirstFilledRoundInfo: loserFirstFilledRoundInfo
        )

        let allMatches = winnerFillingRoundInfo.matches
        + winnerFirstFilledRoundInfo.matches
        + loserFillingRoundInfo.matches
        + loserFirstFilledRoundInfo.matches
        + winnerRecursiveRoundsInfo.matches

        return Bracket(
            name: "\(name) (\(participants.count))",
            createdAt: Date(),
            matches: .init(uniqueElements: allMatches)
        )
    }

}

// MARK: - Basic Info
private extension Bracket {

    static var viablePowersOfTwo: [Int] {
        [4, 8, 16]
    }

    struct BasicInfo: Equatable {
        let numberOfParticipants: Int
        let greatestFillablePowerOfTwo: Int
    }
    static func generateBasicInfo(
        participants: [Participant]
    ) -> BasicInfo {
        let numberOfParticipants = participants.count
        let greatestFillablePowerOfTwo = viablePowersOfTwo
            .filter { $0 <= numberOfParticipants }.max()!
        return BasicInfo(
            numberOfParticipants: numberOfParticipants,
            greatestFillablePowerOfTwo: greatestFillablePowerOfTwo
        )
    }

}

// MARK: - Winners Bracket
private extension Bracket {

    struct WinnerFillingRoundInfo: Equatable {
        let numberOfParticipants: Int
        let everyOtherParticipant: [Int]
        let matches: [Match]
        let lastMatchNumber: MatchNumber?
    }
    static func generateWinnerFillingRoundInfo(
        basicInfo: BasicInfo,
        participants: [Participant]
    ) -> WinnerFillingRoundInfo {
        let numberOfParticipants = (basicInfo.numberOfParticipants - basicInfo.greatestFillablePowerOfTwo) * 2
        let everyOtherParticipant = stride(from: 0, to: numberOfParticipants, by: 2)
        let matches = everyOtherParticipant.enumerated().map { (offset, participantIndex) in
            let matchNumber = MatchNumber(offset + 1)
            return Match(
                matchNumber: matchNumber,
                participant1: .participant(participants[participantIndex]),
                participant2: .participant(participants[participantIndex + 1]),
                kind: .default,
                side: .winners,
                round: 1
            )
        }
        let lastMatchNumber = matches.last?.matchNumber
        return WinnerFillingRoundInfo(
            numberOfParticipants: numberOfParticipants,
            everyOtherParticipant: Array(everyOtherParticipant),
            matches: matches,
            lastMatchNumber: lastMatchNumber
        )
    }

    struct WinnerFirstFilledRoundInfo: Equatable {
        let roundNumber: Round
        let numberOfMatches: Int
        let numberOfParticipantsWithBye: Int
        let lastMatchNumber: MatchNumber
        struct SingleByeMatchInfo: Equatable {
            let numberOfParticipants: Int
            let participantIndices: [Int]
            let matches: [Match]
            let lastMatchNumber: MatchNumber?
        }
        let singleByeMatchInfo: SingleByeMatchInfo
        struct ZeroByeMatchInfo: Equatable {
            let matches: [Match]
            let lastMatchNumber: MatchNumber?
        }
        let zeroByeMatchInfo: ZeroByeMatchInfo
        struct DoubleByeMatchInfo: Equatable {
            let numberOfMatches: Int
            let numberOfParticipants: Int
            let everyOtherParticipant: [Int]
            let matches: [Match]
            let lastMatchNumber: MatchNumber?
        }
        let doubleByeMatchInfo: DoubleByeMatchInfo

        var matches: [Match] {
            singleByeMatchInfo.matches + zeroByeMatchInfo.matches + doubleByeMatchInfo.matches
        }
    }
    static func generateWinnerFirstFilledRoundInfo(
        basicInfo: BasicInfo,
        winnerFillingRoundInfo: WinnerFillingRoundInfo,
        participants: [Participant]
    ) -> WinnerFirstFilledRoundInfo {
        let roundNumber: Round = winnerFillingRoundInfo.matches.isEmpty ? 1 : 2
        let numberOfMatches = basicInfo.greatestFillablePowerOfTwo / 2
        let numberOfParticipantsWithBye = basicInfo.numberOfParticipants - winnerFillingRoundInfo.numberOfParticipants

        let numberOfDoubleByeMatches = max(
            numberOfParticipantsWithBye - numberOfMatches,
            0
        )
        let numberOfDoubleByeParticipants = numberOfDoubleByeMatches * 2

        let numberOfSingleByeParticipants = numberOfParticipantsWithBye - numberOfDoubleByeParticipants
        let singleByeFirstParticipantIndex = winnerFillingRoundInfo.numberOfParticipants + numberOfDoubleByeParticipants
        let singleByeLastParticipantIndex = singleByeFirstParticipantIndex + numberOfSingleByeParticipants
        let singleByeParticipantIndices = Array(singleByeFirstParticipantIndex..<singleByeLastParticipantIndex)
        let singleByeMatches = zip(
            winnerFillingRoundInfo.matches.prefix(numberOfSingleByeParticipants),
            singleByeParticipantIndices
        ).enumerated().map { (offset, element) in
            let (fillingRoundMatch, participantIndex) = element
            let startMatchNumber = (winnerFillingRoundInfo.lastMatchNumber ?? 0) + 1
            let matchNumber = startMatchNumber + MatchNumber(offset)
            return Match(
                matchNumber: matchNumber,
                participant1: .participant(participants[participantIndex]),
                participant2: .awaitingWinner(fillingRoundMatch.matchNumber),
                kind: .default,
                side: .winners,
                round: roundNumber
            )
        }
        let singleByeLastMatchNumber = singleByeMatches.last?.matchNumber

        let zeroByeMatchIndices = stride(from: singleByeMatches.count, to: winnerFillingRoundInfo.matches.count, by: 2)
        let zeroByeMatches = zeroByeMatchIndices.enumerated().map { (offset, matchIndex) in
            let startMatchNumber = (singleByeLastMatchNumber ?? winnerFillingRoundInfo.lastMatchNumber ?? 0) + 1
            let matchNumber = startMatchNumber + MatchNumber(offset)
            return Match(
                matchNumber: matchNumber,
                participant1: .awaitingWinner(winnerFillingRoundInfo.matches[matchIndex].matchNumber),
                participant2: .awaitingWinner(winnerFillingRoundInfo.matches[matchIndex + 1].matchNumber),
                kind: .default,
                side: .winners,
                round: roundNumber
            )
        }
        let zeroByeLastMatchNumber = zeroByeMatches.last?.matchNumber

        let everyOtherDoubleByeParticipant = stride(
            from: winnerFillingRoundInfo.numberOfParticipants,
            to: winnerFillingRoundInfo.numberOfParticipants + numberOfDoubleByeParticipants,
            by: 2
        )
        let doubleByeMatches = everyOtherDoubleByeParticipant.enumerated().map { (offset, participantIndex) in
            let startMatchNumber = (zeroByeLastMatchNumber ?? singleByeLastMatchNumber ?? winnerFillingRoundInfo.lastMatchNumber ?? 0) + 1
            let matchNumber = startMatchNumber + MatchNumber(offset)
            return Match(
                matchNumber: matchNumber,
                participant1: .participant(participants[participantIndex]),
                participant2: .participant(participants[participantIndex + 1]),
                kind: .default,
                side: .winners,
                round: roundNumber
            )
        }
        let doubleByeLastMatchNumber = doubleByeMatches.last?.matchNumber

        let lastMatchNumber = (doubleByeLastMatchNumber ?? zeroByeLastMatchNumber ?? singleByeLastMatchNumber)!

        return WinnerFirstFilledRoundInfo(
            roundNumber: roundNumber,
            numberOfMatches: numberOfMatches,
            numberOfParticipantsWithBye: numberOfParticipantsWithBye,
            lastMatchNumber: lastMatchNumber,
            singleByeMatchInfo: WinnerFirstFilledRoundInfo.SingleByeMatchInfo(
                numberOfParticipants: numberOfSingleByeParticipants,
                participantIndices: singleByeParticipantIndices,
                matches: singleByeMatches,
                lastMatchNumber: singleByeLastMatchNumber
            ),
            zeroByeMatchInfo: WinnerFirstFilledRoundInfo.ZeroByeMatchInfo(
                matches: zeroByeMatches,
                lastMatchNumber: zeroByeLastMatchNumber
            ),
            doubleByeMatchInfo: WinnerFirstFilledRoundInfo.DoubleByeMatchInfo(
                numberOfMatches: numberOfDoubleByeMatches,
                numberOfParticipants: numberOfDoubleByeParticipants,
                everyOtherParticipant: Array(everyOtherDoubleByeParticipant),
                matches: doubleByeMatches,
                lastMatchNumber: doubleByeLastMatchNumber
            )
        )
    }

    struct WinnerRecursiveRoundsInfo: Equatable {
        let matches: [Match]
    }
    static func generateWinnerRecursiveRoundsInfo(
        winnerFirstFilledRoundInfo: WinnerFirstFilledRoundInfo,
        loserFirstFilledRoundInfo: LoserFirstFilledRoundInfo
    ) -> WinnerRecursiveRoundsInfo {

        func recurse(
            _ matches: [Match],
            startMatchNumber: MatchNumber,
            round: Round
        ) -> [Match] {
            guard matches.count > 1 else {
                return []
            }
            let nextRoundMatches = stride(from: 0, to: matches.endIndex, by: 2)
                .enumerated()
                .map { offset, matchIndex in
                    let matchNumber = startMatchNumber + MatchNumber(offset)
                    return Match(
                        matchNumber: matchNumber,
                        participant1: .awaitingWinner(matches[matchIndex].matchNumber),
                        participant2: .awaitingWinner(matches[matchIndex + 1].matchNumber),
                        kind: matches.count == 2 ? .championship : .default,
                        side: .winners,
                        round: round
                    )
                }
            let nextStartMatchNumber = nextRoundMatches.last!.matchNumber + 1
            let nextRoundNumber = round + 1
            return nextRoundMatches + recurse(
                nextRoundMatches,
                startMatchNumber: nextStartMatchNumber,
                round: nextRoundNumber
            )
        }

        let matches = recurse(
            winnerFirstFilledRoundInfo.matches,
            startMatchNumber: loserFirstFilledRoundInfo.lastMatchNumber + 1,
            round: winnerFirstFilledRoundInfo.roundNumber + 1
        )

        return WinnerRecursiveRoundsInfo(
            matches: matches
        )
    }

}

// MARK: - Losers Bracket
private extension Bracket {

    struct LoserInitialRoundsInfo: Equatable {
        let numberOfParticipantsInFillingRound: Int
        let numberOfMatchesInFirstFilledRound: Int
        let numberOfWinnerParticipantsWithByeToFirstFilledRound: Int
    }
    static func generateLoserInitialRoundsInfo(
        winnerFillingRoundInfo: WinnerFillingRoundInfo,
        winnerFirstFilledRoundInfo: WinnerFirstFilledRoundInfo
    ) -> LoserInitialRoundsInfo {
        let totalNumberOfWinnerParticipants = winnerFillingRoundInfo.matches.count + winnerFirstFilledRoundInfo.matches.count
        let numberOfParticipantsInFirstFilledRound = viablePowersOfTwo
            .filter { $0 <= totalNumberOfWinnerParticipants }.max()!
        let numberOfMatchesInLoserFillingRound = totalNumberOfWinnerParticipants - numberOfParticipantsInFirstFilledRound
        let numberOfWinnerParticipantsWithByeToFirstFilledRound = totalNumberOfWinnerParticipants - (numberOfMatchesInLoserFillingRound * 2)
        let numberOfParticipantsInLoserFillingRound = numberOfMatchesInLoserFillingRound * 2
        return LoserInitialRoundsInfo(
            numberOfParticipantsInFillingRound: numberOfParticipantsInLoserFillingRound,
            numberOfMatchesInFirstFilledRound: numberOfParticipantsInFirstFilledRound / 2,
            numberOfWinnerParticipantsWithByeToFirstFilledRound: numberOfWinnerParticipantsWithByeToFirstFilledRound
        )
    }

    static func priorityOrderedWinnerMatchParticipants(
        winnerFillingRoundInfo: WinnerFillingRoundInfo,
        winnerFirstFilledRoundInfo: WinnerFirstFilledRoundInfo
    ) -> [Match] {
        return winnerFirstFilledRoundInfo.doubleByeMatchInfo.matches
        + winnerFillingRoundInfo.matches
        + winnerFirstFilledRoundInfo.singleByeMatchInfo.matches
        + winnerFirstFilledRoundInfo.zeroByeMatchInfo.matches
    }

    struct LoserFillingRoundInfo: Equatable {
        let matches: [Match]
        let lastMatchNumber: MatchNumber
    }
    static func generateLoserFillingRoundInfo(
        loserInitialRoundsInfo: LoserInitialRoundsInfo,
        winnerFillingRoundInfo: WinnerFillingRoundInfo,
        winnerFirstFilledRoundInfo: WinnerFirstFilledRoundInfo
    ) -> LoserFillingRoundInfo {
        let numberOfParticipants = loserInitialRoundsInfo.numberOfParticipantsInFillingRound
        guard numberOfParticipants > 0 else {
            return LoserFillingRoundInfo(
                matches: [],
                lastMatchNumber: winnerFirstFilledRoundInfo.lastMatchNumber
            )
        }
        let matchParticipants = priorityOrderedWinnerMatchParticipants(
            winnerFillingRoundInfo: winnerFillingRoundInfo,
            winnerFirstFilledRoundInfo: winnerFirstFilledRoundInfo
        )
            .prefix(numberOfParticipants)
            .map { match in MatchParticipant.awaitingLoser(match.matchNumber) }
        let startMatchNumber = winnerFirstFilledRoundInfo.lastMatchNumber + 1
        let matches = stride(from: 0, to: matchParticipants.endIndex, by: 2)
            .enumerated()
            .map { offset, matchParticipantIndex in
                Match(
                    matchNumber: startMatchNumber + MatchNumber(offset),
                    participant1: matchParticipants[matchParticipantIndex],
                    participant2: matchParticipants[matchParticipantIndex + 1],
                    kind: .default,
                    side: .losers,
                    round: 1
                )
            }
        return LoserFillingRoundInfo(
            matches: matches,
            lastMatchNumber: matches.last!.matchNumber
        )
    }

    struct LoserFirstFilledRoundInfo: Equatable {
        let roundNumber: Round
        let numberOfMatches: Int
        let numberOfParticipantsWithBye: Int
        let lastMatchNumber: MatchNumber
        struct SingleByeMatchInfo: Equatable {
            let numberOfParticipants: Int
            let matches: [Match]
            let lastMatchNumber: MatchNumber?
        }
        let singleByeMatchInfo: SingleByeMatchInfo
        struct ZeroByeMatchInfo: Equatable {
            let matches: [Match]
            let lastMatchNumber: MatchNumber?
        }
        let zeroByeMatchInfo: ZeroByeMatchInfo
        struct DoubleByeMatchInfo: Equatable {
            let numberOfMatches: Int
            let numberOfParticipants: Int
            let matches: [Match]
            let lastMatchNumber: MatchNumber?
        }
        let doubleByeMatchInfo: DoubleByeMatchInfo

        var matches: [Match] {
            singleByeMatchInfo.matches + zeroByeMatchInfo.matches + doubleByeMatchInfo.matches
        }
    }
    static func generateLoserFirstFilledRoundInfo(
        loserInitialRoundsInfo: LoserInitialRoundsInfo,
        loserFillingRoundInfo: LoserFillingRoundInfo,
        winnerFillingRoundInfo: WinnerFillingRoundInfo,
        winnerFirstFilledRoundInfo: WinnerFirstFilledRoundInfo,
        participants: [Participant]
    ) -> LoserFirstFilledRoundInfo {
        let roundNumber: Round = loserFillingRoundInfo.matches.isEmpty ? 1 : 2

        let numberOfParticipantsWithBye = loserInitialRoundsInfo.numberOfWinnerParticipantsWithByeToFirstFilledRound
        let numberOfMatches = loserInitialRoundsInfo.numberOfMatchesInFirstFilledRound

        let numberOfDoubleByeMatches = max(
            numberOfParticipantsWithBye - numberOfMatches,
            0
        )
        let numberOfDoubleByeParticipants = numberOfDoubleByeMatches * 2

        let byeParticipantMatchDestinations = priorityOrderedWinnerMatchParticipants(
            winnerFillingRoundInfo: winnerFillingRoundInfo,
            winnerFirstFilledRoundInfo: winnerFirstFilledRoundInfo
        )
            .dropFirst(loserFillingRoundInfo.matches.count * 2)
            .map { match in MatchParticipant.awaitingLoser(match.matchNumber) }

        let numberOfSingleByeParticipants = numberOfParticipantsWithBye - numberOfDoubleByeParticipants
        let singleByeParticipantDestinations = byeParticipantMatchDestinations.prefix(numberOfSingleByeParticipants)
        let singleByeMatches = zip(
            loserFillingRoundInfo.matches.prefix(numberOfSingleByeParticipants),
            singleByeParticipantDestinations
        ).enumerated().map { (offset, element) in
            let (fillingRoundMatch, byeParticipant) = element
            let startMatchNumber = loserFillingRoundInfo.lastMatchNumber + 1
            let matchNumber = startMatchNumber + MatchNumber(offset)
            return Match(
                matchNumber: matchNumber,
                participant1: byeParticipant,
                participant2: .awaitingWinner(fillingRoundMatch.matchNumber),
                kind: .default,
                side: .losers,
                round: roundNumber
            )
        }
        let singleByeLastMatchNumber = singleByeMatches.last?.matchNumber

        let zeroByeFillingMatches = loserFillingRoundInfo.matches.dropFirst(singleByeMatches.count)
        let everyOtherZeroByeFillingMatch = stride(
            from: zeroByeFillingMatches.startIndex,
            to: zeroByeFillingMatches.endIndex,
            by: 2
        )
        let zeroByeMatches = everyOtherZeroByeFillingMatch.enumerated().map { (offset, matchIndex) in
            let startMatchNumber = (singleByeLastMatchNumber ?? loserFillingRoundInfo.lastMatchNumber) + 1
            let matchNumber = startMatchNumber + MatchNumber(offset)
            return Match(
                matchNumber: matchNumber,
                participant1: .awaitingWinner(zeroByeFillingMatches[matchIndex].matchNumber),
                participant2: .awaitingWinner(zeroByeFillingMatches[matchIndex + 1].matchNumber),
                kind: .default,
                side: .losers,
                round: roundNumber
            )
        }
        let zeroByeLastMatchNumber = zeroByeMatches.last?.matchNumber

        let doubleByeParticipants = byeParticipantMatchDestinations.dropFirst(numberOfSingleByeParticipants)
        let everyOtherDoubleByeParticipant = stride(
            from: doubleByeParticipants.startIndex,
            to: doubleByeParticipants.endIndex,
            by: 2
        )
        let doubleByeMatches = everyOtherDoubleByeParticipant.enumerated().map { (offset, participantIndex) in
            let startMatchNumber = (zeroByeLastMatchNumber ?? singleByeLastMatchNumber ?? loserFillingRoundInfo.lastMatchNumber) + 1
            let matchNumber = startMatchNumber + MatchNumber(offset)
            return Match(
                matchNumber: matchNumber,
                participant1: doubleByeParticipants[participantIndex],
                participant2: doubleByeParticipants[participantIndex + 1],
                kind: .default,
                side: .losers,
                round: roundNumber
            )
        }
        let doubleByeLastMatchNumber = doubleByeMatches.last?.matchNumber

        let lastMatchNumber = (doubleByeLastMatchNumber ?? zeroByeLastMatchNumber ?? singleByeLastMatchNumber)!

        return LoserFirstFilledRoundInfo(
            roundNumber: roundNumber,
            numberOfMatches: numberOfMatches,
            numberOfParticipantsWithBye: numberOfParticipantsWithBye,
            lastMatchNumber: lastMatchNumber,
            singleByeMatchInfo: LoserFirstFilledRoundInfo.SingleByeMatchInfo(
                numberOfParticipants: numberOfSingleByeParticipants,
                matches: singleByeMatches,
                lastMatchNumber: singleByeLastMatchNumber
            ),
            zeroByeMatchInfo: LoserFirstFilledRoundInfo.ZeroByeMatchInfo(
                matches: zeroByeMatches,
                lastMatchNumber: zeroByeLastMatchNumber
            ),
            doubleByeMatchInfo: LoserFirstFilledRoundInfo.DoubleByeMatchInfo(
                numberOfMatches: numberOfDoubleByeMatches,
                numberOfParticipants: numberOfDoubleByeParticipants,
                matches: doubleByeMatches,
                lastMatchNumber: doubleByeLastMatchNumber
            )
        )
    }


}
