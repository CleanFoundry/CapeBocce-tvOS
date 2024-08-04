import DataModel
import IdentifiedCollections
import SwiftUI

struct MatchButtonView: View {

    private let match: Match
    private let allMatches: IdentifiedArrayOf<Match>
    private let tappedWinnerAction: (MatchWinner) -> Void
    private let tappedChampionAction: () -> Void
    @FocusState private var isFocused

    init(
        match: Match,
        allMatches: IdentifiedArrayOf<Match>,
        tappedWinnerAction: @escaping (MatchWinner) -> Void,
        tappedChampionAction: @escaping () -> Void
    ) {
        self.match = match
        self.allMatches = allMatches
        self.tappedWinnerAction = tappedWinnerAction
        self.tappedChampionAction = tappedChampionAction
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            if case let .championship(championshipKind) = match.kind {
                Text(championshipLabelText(championshipKind))
                    .font(.headline)
                    .offset(y: isFocused ? -20 : 0)
                    .scaleEffect(isFocused ? 1.2 : 1)
                    .animation(.snappy, value: isFocused)
            }
            Menu {
                if case let .participant(participant1) = match.participant1,
                   case let .participant(participant2) = match.participant2,
                   match.winner == nil {
                    Button(
                        "\(participant1.name) won",
                        image: participant1.country.bundleImageResource,
                        action: { tappedWinnerAction(.participant1) }
                    )
                    Button(
                        "\(participant2.name) won",
                        image: participant2.country.bundleImageResource,
                        action: { tappedWinnerAction(.participant2) }
                    )
                }
                else if match.winner != nil, match.kind == .championship(.overall) {
                    Button(
                        "Champion Page",
                        systemImage: "trophy",
                        action: { tappedChampionAction() }
                    )
                }
            } label: {
                matchView(match, focused: isFocused)
            }
            .focused($isFocused, equals: true)
            .buttonStyle(
                MatchButtonStyle(
                    focused: isFocused
                )
            )
            if case .championship(.overall) = match.kind {
                overallChampionshipFooterLabel
                    .font(.footnote)
                    .offset(y: isFocused ? 20 : 0)
                    .scaleEffect(isFocused ? 1.2 : 1)
                    .animation(.snappy, value: isFocused)
            }
            Spacer()
        }
        .containerRelativeFrame(.vertical, alignment: .center) { availableHeight, _ in
            let baseHeight = availableHeight / 4
            let scaleFactor = match.heightScaleFactor
            return baseHeight * scaleFactor
        }
        .focusSection()

    }

}

private extension MatchButtonView {

    func matchView(
        _ match: Match,
        focused: Bool
    ) -> some View {
        VStack(spacing: 0) {
            participantLabel(match.participant1, position: .participant1, focused: focused)
                .font(.headline)
            HStack(spacing: 0) {
                VStack(spacing: 8) {
                    Spacer().frame(width: 0, height: 0)
                    HStack {
                        Image(systemName: "\(match.matchNumber).square")
                            .font(.title2)
                            .foregroundStyle(focused ? AnyShapeStyle(.tint) : AnyShapeStyle(.primary))
                        Spacer()
                        Text("VS")
                            .font(.caption)
                            .foregroundStyle(focused ? AnyShapeStyle(.tint) : AnyShapeStyle(.primary))
                        Spacer()
                    }
                    participantLabel(match.participant2, position: .participant2, focused: focused)
                        .font(.headline)
                }
                .overlay(alignment: .trailing) {
                    participantBorderView(along: .vertical, focused: focused)
                }
                .overlay(alignment: .trailing) {
                    Rectangle()
                        .foregroundStyle(focused ? AnyShapeStyle(.black) : AnyShapeStyle(.primary))
                        .frame(width: 18, height: 2)
                        .offset(x: 18)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    func participantLabel(
        _ matchParticipant: MatchParticipant,
        position: MatchWinner,
        focused: Bool
    ) -> some View {
        HStack(spacing: 8) {
            switch matchParticipant {
            case let .participant(participant):
                participant.country.bundleAsset
                    .resizable()
                    .frame(width: 60, height: 40, alignment: .bottomTrailing)
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    participantText(matchParticipant)
                        .foregroundStyle(
                            participantLabelForegroundStyle(
                                matchParticipant,
                                position: position,
                                focused: focused
                            )
                        )
                        .lineLimit(1)
                        .layoutPriority(2)
                        .contentTransition(.interpolate)
                    Spacer()
                        .frame(height: 0)
                        .frame(minWidth: 8)
                    if focused {
                        Text(participant.country.name)
                            .foregroundStyle(
                                participantLabelForegroundStyle(
                                    matchParticipant,
                                    position: position,
                                    focused: focused
                                )
                            )
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                            .layoutPriority(1)
                            .contentTransition(.interpolate)
                        Spacer().frame(width: 8)
                    }
                }
                .overlay(alignment: .bottom) {
                    participantBorderView(along: .horizontal, focused: focused)
                        .foregroundStyle(
                            participantLabelForegroundStyle(
                                matchParticipant,
                                position: position,
                                focused: focused
                            )
                        )
                }
            case .awaitingWinner, .awaitingLoser:
                HStack(spacing: 0) {
                    participantText(matchParticipant)
                        .foregroundStyle(focused ? .black : .primary)
                    Spacer()
                }
                .overlay(alignment: .bottom) {
                    participantBorderView(along: .horizontal, focused: focused)
                }
            }
        }
    }

    func participantLabelForegroundStyle(
        _ matchParticipant: MatchParticipant,
        position: MatchWinner,
        focused: Bool
    ) -> AnyShapeStyle {
        let opacity = [position, nil].contains(match.winner) ? 1 : 0.3
        if focused {
            return AnyShapeStyle(.black.opacity(opacity))
        } else {
            return AnyShapeStyle(.primary.opacity(opacity))
        }
    }

    func participantText(_ participant: MatchParticipant) -> Text {
        switch participant {
        case .participant(let participant):
            Text(participant.name.rawValue)
        case .awaitingWinner(let matchNumber):
            Text("Winner of \(Image(systemName: "\(matchNumber).square"))")
        case .awaitingLoser(let matchNumber):
            Text("Loser of \(Image(systemName: "\(matchNumber).square"))")
        }
    }

    @ViewBuilder func participantBorderView(
        along axis: Axis,
        focused: Bool
    ) -> some View {
        switch axis {
        case .horizontal:
            Rectangle()
                .foregroundStyle(focused ? AnyShapeStyle(.black) : AnyShapeStyle(.primary))
                .frame(height: 2)
                .frame(maxWidth: .infinity)
        case .vertical:
            Rectangle()
                .foregroundStyle(focused ? AnyShapeStyle(.black) : AnyShapeStyle(.primary))
                .frame(width: 2)
                .frame(maxHeight: .infinity)
        }
    }

    func championshipLabelText(_ kind: MatchKind.MatchChampionshipKind) -> String {
        switch kind {
        case .losers:
            "🥉 WAWB Final 🥉"
        case .winners:
            "🥈 WB Final 🥈"
        case .overall:
            "🏅 Championship 🏅"
        }
    }

    @ViewBuilder var overallChampionshipFooterLabel: some View {
        let matchWinner = match.winner.map { matchWinner in
            switch matchWinner {
            case .participant1:
                match.participant1
            case .participant2:
                match.participant2
            }
        }
        if case let .participant(winner) = matchWinner {
            Text("\(winner.name) won!")
        } else {
            (participantText(match.participant2) + Text(" must win twice"))
        }
    }

}
