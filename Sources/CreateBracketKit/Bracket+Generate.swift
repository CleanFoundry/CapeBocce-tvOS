import API
import IdentifiedCollections
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

        let recursiveRoundsInfo = generateRecursiveRoundsInfo(
            winnerFillingRoundInfo: winnerFillingRoundInfo,
            winnerFirstFilledRoundInfo: winnerFirstFilledRoundInfo,
            loserFillingRoundInfo: loserFillingRoundInfo,
            loserFirstFilledRoundInfo: loserFirstFilledRoundInfo
        )

        let allMatches = winnerFillingRoundInfo.matches
        + winnerFirstFilledRoundInfo.matches
        + loserFillingRoundInfo.matches
        + loserFirstFilledRoundInfo.matches
        + recursiveRoundsInfo.matches

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
        [1, 2, 4, 8, 16]
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
        let matches: IdentifiedArrayOf<Match>
        let lastMatchNumber: MatchNumber?
    }
    static func generateWinnerFillingRoundInfo(
        basicInfo: BasicInfo,
        participants: [Participant]
    ) -> WinnerFillingRoundInfo {
        let numberOfParticipants = (basicInfo.numberOfParticipants - basicInfo.greatestFillablePowerOfTwo) * 2
        let everyOtherParticipant = stride(from: 0, to: numberOfParticipants, by: 2)
        let matches = IdentifiedArray(
            uniqueElements: everyOtherParticipant.enumerated().map { (offset, participantIndex) in
                let matchNumber = MatchNumber(offset + 1)
                return Match.default(
                    matchNumber: matchNumber,
                    participant1: .participant(participants[participantIndex]),
                    participant2: .participant(participants[participantIndex + 1]),
                    kind: .default,
                    side: .winners,
                    round: 1,
                    allMatches: []
                )
            }
        )
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
            let matches: IdentifiedArrayOf<Match>
            let lastMatchNumber: MatchNumber?
        }
        let singleByeMatchInfo: SingleByeMatchInfo
        struct ZeroByeMatchInfo: Equatable {
            let matches: IdentifiedArrayOf<Match>
            let lastMatchNumber: MatchNumber?
        }
        let zeroByeMatchInfo: ZeroByeMatchInfo
        struct DoubleByeMatchInfo: Equatable {
            let numberOfMatches: Int
            let numberOfParticipants: Int
            let everyOtherParticipant: [Int]
            let matches: IdentifiedArrayOf<Match>
            let lastMatchNumber: MatchNumber?
        }
        let doubleByeMatchInfo: DoubleByeMatchInfo

        var matches: IdentifiedArrayOf<Match> {
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
        let singleByeMatches = IdentifiedArray(
            uniqueElements: zip(
                winnerFillingRoundInfo.matches.prefix(numberOfSingleByeParticipants),
                singleByeParticipantIndices
            ).enumerated().map { (offset, element) in
                let (fillingRoundMatch, participantIndex) = element
                let startMatchNumber = (winnerFillingRoundInfo.lastMatchNumber ?? 0) + 1
                let matchNumber = startMatchNumber + MatchNumber(offset)
                return Match.default(
                    matchNumber: matchNumber,
                    participant1: .participant(participants[participantIndex]),
                    participant2: .awaitingWinner(fillingRoundMatch.matchNumber),
                    kind: .default,
                    side: .winners,
                    round: roundNumber,
                    allMatches: winnerFillingRoundInfo.matches
                )
            }
        )
        let singleByeLastMatchNumber = singleByeMatches.last?.matchNumber

        let zeroByeMatchIndices = stride(from: singleByeMatches.count, to: winnerFillingRoundInfo.matches.count, by: 2)
        let zeroByeMatches = IdentifiedArray(
            uniqueElements: zeroByeMatchIndices.enumerated().map { (offset, matchIndex) in
                let startMatchNumber = (singleByeLastMatchNumber ?? winnerFillingRoundInfo.lastMatchNumber ?? 0) + 1
                let matchNumber = startMatchNumber + MatchNumber(offset)
                return Match.default(
                    matchNumber: matchNumber,
                    participant1: .awaitingWinner(winnerFillingRoundInfo.matches[matchIndex].matchNumber),
                    participant2: .awaitingWinner(winnerFillingRoundInfo.matches[matchIndex + 1].matchNumber),
                    kind: .default,
                    side: .winners,
                    round: roundNumber,
                    allMatches: winnerFillingRoundInfo.matches + singleByeMatches
                )
            }
        )
        let zeroByeLastMatchNumber = zeroByeMatches.last?.matchNumber

        let everyOtherDoubleByeParticipant = stride(
            from: winnerFillingRoundInfo.numberOfParticipants,
            to: winnerFillingRoundInfo.numberOfParticipants + numberOfDoubleByeParticipants,
            by: 2
        )
        let doubleByeMatches = IdentifiedArray(
            uniqueElements: everyOtherDoubleByeParticipant.enumerated().map { (offset, participantIndex) in
                let startMatchNumber = (zeroByeLastMatchNumber ?? singleByeLastMatchNumber ?? winnerFillingRoundInfo.lastMatchNumber ?? 0) + 1
                let matchNumber = startMatchNumber + MatchNumber(offset)
                return Match.default(
                    matchNumber: matchNumber,
                    participant1: .participant(participants[participantIndex]),
                    participant2: .participant(participants[participantIndex + 1]),
                    kind: .default,
                    side: .winners,
                    round: roundNumber,
                    allMatches: winnerFillingRoundInfo.matches + singleByeMatches + zeroByeMatches
                )
            }
        )
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
    ) -> IdentifiedArrayOf<Match> {
        return winnerFirstFilledRoundInfo.doubleByeMatchInfo.matches
        + winnerFillingRoundInfo.matches
        + winnerFirstFilledRoundInfo.singleByeMatchInfo.matches
        + winnerFirstFilledRoundInfo.zeroByeMatchInfo.matches
    }

    struct LoserFillingRoundInfo: Equatable {
        let matches: IdentifiedArrayOf<Match>
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
        let matches = IdentifiedArray(
            uniqueElements: stride(from: 0, to: matchParticipants.endIndex, by: 2)
                .enumerated()
                .map { offset, matchParticipantIndex in
                    Match.default(
                        matchNumber: startMatchNumber + MatchNumber(offset),
                        participant1: matchParticipants[matchParticipantIndex],
                        participant2: matchParticipants[matchParticipantIndex + 1],
                        kind: .default,
                        side: .losers,
                        round: 1,
                        allMatches: []
                    )
                }
        )
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
            let matches: IdentifiedArrayOf<Match>
            let lastMatchNumber: MatchNumber?
        }
        let singleByeMatchInfo: SingleByeMatchInfo
        struct ZeroByeMatchInfo: Equatable {
            let matches: IdentifiedArrayOf<Match>
            let lastMatchNumber: MatchNumber?
        }
        let zeroByeMatchInfo: ZeroByeMatchInfo
        struct DoubleByeMatchInfo: Equatable {
            let numberOfMatches: Int
            let numberOfParticipants: Int
            let matches: IdentifiedArrayOf<Match>
            let lastMatchNumber: MatchNumber?
        }
        let doubleByeMatchInfo: DoubleByeMatchInfo

        var matches: IdentifiedArrayOf<Match> {
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
            return Match.default(
                matchNumber: matchNumber,
                participant1: byeParticipant,
                participant2: .awaitingWinner(fillingRoundMatch.matchNumber),
                kind: .default,
                side: .losers,
                round: roundNumber,
                allMatches: loserFillingRoundInfo.matches
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
            return Match.default(
                matchNumber: matchNumber,
                participant1: .awaitingWinner(zeroByeFillingMatches[matchIndex].matchNumber),
                participant2: .awaitingWinner(zeroByeFillingMatches[matchIndex + 1].matchNumber),
                kind: .default,
                side: .losers,
                round: roundNumber,
                allMatches: loserFillingRoundInfo.matches
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
            return Match.default(
                matchNumber: matchNumber,
                participant1: doubleByeParticipants[participantIndex],
                participant2: doubleByeParticipants[participantIndex + 1],
                kind: .default,
                side: .losers,
                round: roundNumber,
                allMatches: loserFillingRoundInfo.matches
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
                matches: IdentifiedArray(uniqueElements: singleByeMatches),
                lastMatchNumber: singleByeLastMatchNumber
            ),
            zeroByeMatchInfo: LoserFirstFilledRoundInfo.ZeroByeMatchInfo(
                matches: IdentifiedArray(uniqueElements: zeroByeMatches),
                lastMatchNumber: zeroByeLastMatchNumber
            ),
            doubleByeMatchInfo: LoserFirstFilledRoundInfo.DoubleByeMatchInfo(
                numberOfMatches: numberOfDoubleByeMatches,
                numberOfParticipants: numberOfDoubleByeParticipants,
                matches: IdentifiedArray(uniqueElements: doubleByeMatches),
                lastMatchNumber: doubleByeLastMatchNumber
            )
        )
    }


}

private extension Bracket {

    struct RecursiveRoundsInfo {
        let matches: IdentifiedArrayOf<Match>
    }
    static func generateRecursiveRoundsInfo(
        winnerFillingRoundInfo: WinnerFillingRoundInfo,
        winnerFirstFilledRoundInfo: WinnerFirstFilledRoundInfo,
        loserFillingRoundInfo: LoserFillingRoundInfo,
        loserFirstFilledRoundInfo: LoserFirstFilledRoundInfo
    ) -> RecursiveRoundsInfo {

        struct NextWinnerRoundMatches {
            let matches: IdentifiedArrayOf<Match>
            let lastMatchNumber: MatchNumber
        }
        func nextWinnerRoundMatches(
            previousWinnerRoundMatches: IdentifiedArrayOf<Match>,
            startMatchNumber: MatchNumber,
            round: Round,
            allPreviousMatches: IdentifiedArrayOf<Match>
        ) -> NextWinnerRoundMatches {
            guard previousWinnerRoundMatches.count > 1 else {
                return NextWinnerRoundMatches(
                    matches: [],
                    lastMatchNumber: startMatchNumber - 1
                )
            }
            let matches = stride(from: 0, to: previousWinnerRoundMatches.endIndex, by: 2)
                .enumerated()
                .map { offset, matchIndex in
                    let matchNumber = startMatchNumber + MatchNumber(offset)
                    return Match.default(
                        matchNumber: matchNumber,
                        participant1: .awaitingWinner(
                            previousWinnerRoundMatches[matchIndex].matchNumber
                        ),
                        participant2: .awaitingWinner(
                            previousWinnerRoundMatches[matchIndex + 1].matchNumber
                        ),
                        kind: previousWinnerRoundMatches.count == 2 ?
                            .championship(.winners) : .default,
                        side: .winners,
                        round: round,
                        allMatches: allPreviousMatches
                    )
                }
            let lastMatchNumber = matches.last?.matchNumber ?? startMatchNumber
            return NextWinnerRoundMatches(
                matches: IdentifiedArray(uniqueElements: matches),
                lastMatchNumber: lastMatchNumber
            )
        }

        struct NextLoserRoundMatches {
            let matches: IdentifiedArrayOf<Match>
            let lastMatchNumber: MatchNumber
            let didIncorporateWinnerRoundMatches: Bool
        }
        func nextLoserRoundMatches(
            latestUnincorportatedWinnerRoundMatches: IdentifiedArrayOf<Match>,
            previousLoserRoundMatches: IdentifiedArrayOf<Match>,
            startMatchNumber: MatchNumber,
            round: Round,
            allPreviousMatches: IdentifiedArrayOf<Match>
        ) -> NextLoserRoundMatches {
            let shouldIncorporateWinnerRound = previousLoserRoundMatches.count == latestUnincorportatedWinnerRoundMatches.count
            if shouldIncorporateWinnerRound {
                let matches = zip(
                    latestUnincorportatedWinnerRoundMatches,
                    previousLoserRoundMatches
                ).enumerated().map { offset, tuple in
                    let (winnerMatch, loserMatch) = tuple
                    let matchNumber = startMatchNumber + MatchNumber(offset)
                    return Match.default(
                        matchNumber: matchNumber,
                        participant1: .awaitingLoser(winnerMatch.matchNumber),
                        participant2: .awaitingWinner(loserMatch.matchNumber),
                        kind: .default,
                        side: .losers,
                        round: round,
                        allMatches: allPreviousMatches
                    )
                }
                let lastMatchNumber = matches.last?.matchNumber ?? startMatchNumber
                return NextLoserRoundMatches(
                    matches: IdentifiedArray(uniqueElements: matches),
                    lastMatchNumber: lastMatchNumber,
                    didIncorporateWinnerRoundMatches: true
                )
            } else {
                guard previousLoserRoundMatches.count > 1 else {
                    return NextLoserRoundMatches(
                        matches: [],
                        lastMatchNumber: startMatchNumber - 1,
                        didIncorporateWinnerRoundMatches: false
                    )
                }
                let matches = stride(from: 0, to: previousLoserRoundMatches.endIndex, by: 2)
                    .enumerated()
                    .map { offset, matchIndex in
                        let matchNumber = startMatchNumber + MatchNumber(offset)
                        return Match.default(
                            matchNumber: matchNumber,
                            participant1: .awaitingWinner(
                                previousLoserRoundMatches[matchIndex].matchNumber
                            ),
                            participant2: .awaitingWinner(
                                previousLoserRoundMatches[matchIndex + 1].matchNumber
                            ),
                            kind: previousLoserRoundMatches.count == 2 ? .championship(.losers) : .default,
                            side: .losers,
                            round: round,
                            allMatches: previousLoserRoundMatches
                        )
                    }
                let lastMatchNumber = matches.last?.matchNumber ?? startMatchNumber
                return NextLoserRoundMatches(
                    matches: IdentifiedArray(uniqueElements: matches),
                    lastMatchNumber: lastMatchNumber,
                    didIncorporateWinnerRoundMatches: false
                )
            }
        }

        func recurse(
            previousWinnerMatches: IdentifiedArrayOf<Match>,
            previousLoserMatches: IdentifiedArrayOf<Match>,
            startMatchNumber: MatchNumber,
            winnerRound: Round,
            loserRound: Round,
            unincorporatedWinnerMatches: inout [IdentifiedArrayOf<Match>],
            allPreviousMatches: IdentifiedArrayOf<Match>
        ) -> IdentifiedArrayOf<Match> {
            let nextWinnerRoundMatches = nextWinnerRoundMatches(
                previousWinnerRoundMatches: previousWinnerMatches,
                startMatchNumber: startMatchNumber,
                round: winnerRound,
                allPreviousMatches: allPreviousMatches
            )
            unincorporatedWinnerMatches.append(nextWinnerRoundMatches.matches)
            let nextUnincorporatedWinnerMatches = unincorporatedWinnerMatches.first!
            let nextLoserRoundMatches = nextLoserRoundMatches(
                latestUnincorportatedWinnerRoundMatches: nextUnincorporatedWinnerMatches,
                previousLoserRoundMatches: previousLoserMatches,
                startMatchNumber: nextWinnerRoundMatches.lastMatchNumber + 1,
                round: loserRound,
                allPreviousMatches: allPreviousMatches
            )
            if nextLoserRoundMatches.didIncorporateWinnerRoundMatches {
                unincorporatedWinnerMatches.removeFirst()
            }
            let currentIterationMatches = nextWinnerRoundMatches.matches + nextLoserRoundMatches.matches
            guard !currentIterationMatches.isEmpty else {
                return []
            }
            return currentIterationMatches + recurse(
                previousWinnerMatches: nextWinnerRoundMatches.matches,
                previousLoserMatches: nextLoserRoundMatches.matches,
                startMatchNumber: nextLoserRoundMatches.lastMatchNumber + 1,
                winnerRound: winnerRound + 1,
                loserRound: loserRound + 1,
                unincorporatedWinnerMatches: &unincorporatedWinnerMatches,
                allPreviousMatches: allPreviousMatches + currentIterationMatches
            )
        }

        let allPreviousMatches = winnerFillingRoundInfo.matches
        + winnerFirstFilledRoundInfo.matches
        + loserFillingRoundInfo.matches
        + loserFirstFilledRoundInfo.matches
        var unincorporatedWinnerMatches: [IdentifiedArrayOf<Match>] = []
        let recursiveMatches = recurse(
            previousWinnerMatches: winnerFirstFilledRoundInfo.matches,
            previousLoserMatches: loserFirstFilledRoundInfo.matches,
            startMatchNumber: loserFirstFilledRoundInfo.lastMatchNumber + 1,
            winnerRound: winnerFirstFilledRoundInfo.roundNumber + 1,
            loserRound: loserFirstFilledRoundInfo.roundNumber + 1,
            unincorporatedWinnerMatches: &unincorporatedWinnerMatches,
            allPreviousMatches: allPreviousMatches
        )

        guard let winnerFinal = recursiveMatches.first(where: { $0.kind == .championship(.winners) }),
              let loserFinal = recursiveMatches.first(where: { $0.kind == .championship(.losers) }),
              let maxMatchNumber = recursiveMatches.map(\.matchNumber).max(),
              let maxWinnerRound = recursiveMatches.filter({ $0.side == .winners }).map(\.round).max()
        else {
            fatalError()
        }

        let championshipMatch = Match.default(
            matchNumber: maxMatchNumber + 1,
            participant1: .awaitingWinner(winnerFinal.matchNumber),
            participant2: .awaitingWinner(loserFinal.matchNumber),
            kind: .championship(.overall),
            side: .winners,
            round: maxWinnerRound + 1,
            allMatches: allPreviousMatches + recursiveMatches
        )

        return RecursiveRoundsInfo(matches: recursiveMatches + [championshipMatch])
    }

}

private extension Match {

    static func `default`(
        matchNumber: MatchNumber,
        participant1: MatchParticipant,
        participant2: MatchParticipant,
        kind: MatchKind,
        side: MatchBracketSide,
        round: Round,
        allMatches: IdentifiedArrayOf<Match>
    ) -> Match {
        return Match(
            matchNumber: matchNumber,
            participant1: participant1,
            participant2: participant2,
            winner: nil,
            heightScaleFactor: defaultScaleFactor(
                participant1: participant1,
                participant2: participant2,
                side: side,
                allMatches: allMatches
            ),
            kind: kind,
            side: side,
            round: round
        )
    }

    private static func defaultScaleFactor(
        participant1: MatchParticipant,
        participant2: MatchParticipant,
        side: MatchBracketSide,
        allMatches: IdentifiedArrayOf<Match>
    ) -> CGFloat {
        var base: CGFloat = 0
        if
            case .awaitingWinner(let p1ID) = participant1,
            let p1 = allMatches[id: p1ID],
            p1.side == side {

            base += defaultScaleFactor(
                participant1: p1.participant1,
                participant2: p1.participant2,
                side: side,
                allMatches: allMatches
            )
        }
        if
            case .awaitingWinner(let p2ID) = participant2,
            let p2 = allMatches[id: p2ID],
            p2.side == side {

            base += defaultScaleFactor(
                participant1: p2.participant1,
                participant2: p2.participant2,
                side: side,
                allMatches: allMatches
            )
        }
        return max(base, 1)
    }

}
