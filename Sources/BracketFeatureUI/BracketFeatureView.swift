import API
import APIExtensions
import BracketFeatureKit
import ComposableArchitecture
import SwiftUI

public struct BracketFeatureView: View {

    @Bindable var store: StoreOf<BracketFeature>
    @FocusState var focusedMatchNumber: MatchNumber?
    @Namespace var namespace

    public init(store: StoreOf<BracketFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            ScrollView([.horizontal, .vertical]) {
                VStack(alignment: .leading) {
                    if let winnersMatches = store.groupedMatches[.winners] {
                        Section {
                            bracketSide(
                                groupedMatches: winnersMatches
                            )
                            .frame(maxWidth: .infinity)
                        } header: {
                            Text("Winners’ Bracket")
                                .font(.title2)
                        }
                    }
                    if let losersMatches = store.groupedMatches[.losers] {
                        Text("We’re All Winners Bracket")
                        bracketSide(
                            groupedMatches: losersMatches
                        )
                    }
                }
                .containerRelativeFrame([.horizontal]) { value, _ in value }
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
                    let matches = groupedMatches[round]!
                    Text("Round \(round)")
                    ForEach(matches) { match in
                        matchButton(match)
                    }
                    Spacer()
                }
                .containerRelativeFrame([.horizontal]) { value, _ in
                    value / 4
                }
            }
            Spacer()
        }
    }

    func matchButton(
        _ match: Match
    ) -> some View {
        Button { } label: {
            matchView(match, focused: focusedMatchNumber == match.matchNumber)
        }
        .focused(
            $focusedMatchNumber,
            equals: match.matchNumber
        )
        .buttonStyle(CustomButtonStyle(focused: focusedMatchNumber == match.matchNumber))

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
                            .foregroundStyle(focused ? AnyShapeStyle(.black) : AnyShapeStyle(.tint))
                        Spacer()
                        Text("VS")
                            .font(.caption)
                            .foregroundStyle(focused ? .black : .primary)
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
                        .foregroundStyle(focused ? AnyShapeStyle(.black) : AnyShapeStyle(.tint))
                        .frame(width: 36, height: 2)
                        .offset(x: 36)
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
                HStack(spacing: 8) {
                    Text(participant.name)
                        .foregroundStyle(focused ? .black : .primary)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    if focused {
                        Text(participant.country.name)
                            .foregroundStyle(.black)
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .fixedSize(horizontal: false, vertical: true)
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
                .foregroundStyle(focused ? AnyShapeStyle(.black) : AnyShapeStyle(.tint))
                .frame(height: 2)
                .frame(maxWidth: .infinity)
        case .vertical:
            Rectangle()
                .foregroundStyle(focused ? AnyShapeStyle(.black) : AnyShapeStyle(.tint))
                .frame(width: 2)
                .frame(maxHeight: .infinity)
        }
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
                    .foregroundStyle(focused ? .primary : .secondary)
            )
            .scaleEffect(focused ? 1.1 : 1.0)
            .animation(.snappy, value: focused)
    }

}
