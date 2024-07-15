import API
import APIExtensions
import BracketFeatureKit
import ComposableArchitecture
import SwiftUI

public struct BracketFeatureView: View {

    @Bindable var store: StoreOf<BracketFeature>
    @FocusState var focusedMatchNumber: MatchNumber?

    public init(store: StoreOf<BracketFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            ScrollView([.horizontal, .vertical]) {
                VStack {
                    if let winnersMatches = store.groupedMatches[.winners] {
                        HStack {
                            Text("Winners’ Bracket")
                                .font(.title2)
                            Spacer()
                        }
                        bracketSide(
                            groupedMatches: winnersMatches
                        )
                    }
                    if let losersMatches = store.groupedMatches[.losers] {
                        HStack {
                            Text("We’re All Winners Bracket")
                                .font(.title2)
                            Spacer()
                        }
                        bracketSide(
                            groupedMatches: losersMatches
                        )
                    }
                }
                .navigationTitle(store.bracketName)
            }
        }
    }
}

private extension BracketFeatureView {

    func bracketSide(
        groupedMatches: [Round: IdentifiedArrayOf<Match>]
    ) -> some View {
        HStack(alignment: .top) {
            ForEach(Array(groupedMatches.keys).sorted(), id: \.self) { round in
                VStack {
                    let matches = groupedMatches[round]!.sorted(using: KeyPathComparator(\.matchNumber))
                    Text("Round \(round)")
                        .font(.subheadline)
                    ForEach(matches) { match in
                        matchButtonView(match)
                    }
                    Spacer()
                }
                .containerRelativeFrame([.horizontal]) { value, _ in
                    value / 4
                }
            }
            Spacer()
        }
        .focusSection()
    }

    func matchButtonView(
        _ match: Match
    ) -> some View {
        VStack(spacing: 0) {
            Spacer()
            Button { } label: {
                matchView(match, focused: focusedMatchNumber == match.matchNumber)
            }
            .focused(
                $focusedMatchNumber,
                equals: match.matchNumber
            )
            .buttonStyle(CustomButtonStyle(focused: focusedMatchNumber == match.matchNumber))
            Spacer()
        }
        .containerRelativeFrame(.vertical, alignment: .center) { availableHeight, _ in
            let baseHeight = availableHeight / 4
            let scaleFactor = heightScaleFactor(for: match)
            return baseHeight * scaleFactor
        }
        .focusSection()
    }

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
        if case .awaitingWinner(let p1ID) = match.participant1, let p1 = store.matches[id: p1ID] {
            base += heightScaleFactor(for: p1)
        }
        if case .awaitingWinner(let p2ID) = match.participant2, let p2 = store.matches[id: p2ID] {
            base += heightScaleFactor(for: p2)
        }
        return max(base, 1)
    }

}

struct CustomButtonStyle: ButtonStyle {

    private let focused: Bool

    init(focused: Bool) {
        self.focused = focused
    }

    @ViewBuilder func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(focused ? .secondary : .tertiary)
                    .strokeBorder(.tint, lineWidth: focused ? 4 : 0)
            )
            .scaleEffect(focused ? 1.2 : 1.0)
            .animation(.snappy, value: focused)
    }

}
