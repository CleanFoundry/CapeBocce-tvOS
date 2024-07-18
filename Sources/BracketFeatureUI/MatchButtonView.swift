import API
import IdentifiedCollections
import SwiftUI

struct MatchButtonView: View {

    private let match: Match
    private let allMatches: IdentifiedArrayOf<Match>
    @FocusState private var isFocused

    init(
        match: Match,
        allMatches: IdentifiedArrayOf<Match>
    ) {
        self.match = match
        self.allMatches = allMatches
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            if case let .championship(championshipKind) = match.kind {
                Text("🏆 Championship 🏆")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .offset(y: isFocused ? -20 : 0)
                    .scaleEffect(isFocused ? 1.2 : 1)
                    .animation(.snappy, value: isFocused)
            }
            Button { } label: {
                matchView(match, focused: isFocused)
            }
            .focused($isFocused, equals: true)
            .buttonStyle(MatchButtonStyle(focused: isFocused))
            Spacer()
        }
        .containerRelativeFrame(.vertical, alignment: .center) { availableHeight, _ in
            let baseHeight = availableHeight / 4
            let scaleFactor = heightScaleFactor(for: match)
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
            participantLabel(match.participant1, focused: focused)
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
                    participantLabel(match.participant2, focused: focused)
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
        _ participant: MatchParticipant,
        focused: Bool
    ) -> some View {
        HStack(spacing: 8) {
            switch participant {
            case let .participant(participant):
                participant.country.bundleAsset
                    .resizable()
                    .frame(width: 60, height: 40, alignment: .bottomTrailing)
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(participant.name)
                        .foregroundStyle(focused ? .black : .primary)
                        .lineLimit(1)
                        .layoutPriority(2)
                    Spacer()
                        .frame(height: 0)
                        .frame(minWidth: 8)
                    if focused {
                        Text(participant.country.name)
                            .foregroundStyle(.black)
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                            .layoutPriority(1)
                        Spacer().frame(width: 8)
                    }
                }
                .overlay(alignment: .bottom) {
                    participantBorderView(along: .horizontal, focused: focused)
                }
            case let .awaitingWinner(matchNumber):
                HStack(spacing: 0) {
                    Text("Winner of \(Image(systemName: "\(matchNumber).square"))")
                        .foregroundStyle(focused ? .black : .primary)
                    Spacer()
                }
                .overlay(alignment: .bottom) {
                    participantBorderView(along: .horizontal, focused: focused)
                }
            case let .awaitingLoser(matchNumber):
                HStack(spacing: 0) {
                    Text("Loser of \(Image(systemName: "\(matchNumber).square"))")
                        .foregroundStyle(focused ? .black : .primary)
                    Spacer()
                }
                .overlay(alignment: .bottom) {
                    participantBorderView(along: .horizontal, focused: focused)
                }
            }
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


    func heightScaleFactor(for match: Match) -> CGFloat {
        var base: CGFloat = 0
        if case .awaitingWinner(let p1ID) = match.participant1, let p1 = allMatches[id: p1ID] {
            base += heightScaleFactor(for: p1)
        }
        if case .awaitingWinner(let p2ID) = match.participant2, let p2 = allMatches[id: p2ID] {
            base += heightScaleFactor(for: p2)
        }
        return max(base, 1)
    }

}
