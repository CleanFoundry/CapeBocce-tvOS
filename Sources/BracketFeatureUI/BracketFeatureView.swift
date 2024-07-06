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
            ScrollView {
                if let winnersMatches = store.groupedMatches[.winners] {
                    bracketSide(
                        groupedMatches: winnersMatches,
                        title: "Winners’ Bracket"
                    )
                }
                if let losersMatches = store.groupedMatches[.losers] {
                    bracketSide(
                        groupedMatches: losersMatches,
                        title: "We’re All Winners Bracket"
                    )
                }
            }
            .navigationTitle(store.bracketName)
        }
    }

}

private extension BracketFeatureView {

    func bracketSide(
        groupedMatches: [Round: IdentifiedArrayOf<Match>],
        title: String
    ) -> some View {
        Section(title) {
            HStack(alignment: .top) {
                ForEach(Array(groupedMatches.keys).sorted(), id: \.self) { round in
                    VStack {
                        let matches = groupedMatches[round]!
                        Text("Round \(round)")
                        ForEach(matches) { match in
                            Button { } label: {
                                matchView(match: match, focused: focusedMatchNumber == match.matchNumber)
                            }
                            .focused($focusedMatchNumber, equals: match.matchNumber)
                            .buttonStyle(CustomButtonStyle(focused: focusedMatchNumber == match.matchNumber))
                        }
                        Spacer()
                    }
                    .containerRelativeFrame([.horizontal, .vertical]) { value, axis in
                        switch axis {
                        case .horizontal:
                            value / 4
                        case .vertical:
                            value * 3 / 4
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    func matchView(
        match: Match,
        focused: Bool
    ) -> some View {
        VStack(spacing: 8) {
            participantLabel(match.participant1, focused: focused)
                .font(.headline)
                .overlay(alignment: .bottom) {
                    (focused ? Color.black : Color.yellow)
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                }
            Text("VS")
                .font(.caption)
                .foregroundStyle(focused ? .black : .primary)
            participantLabel(match.participant2, focused: focused)
                .font(.headline)
                .overlay(alignment: .bottom) {
                    (focused ? Color.black : Color.yellow)
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
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
                Text(participant.name)
                    .foregroundStyle(focused ? .black : .primary)
            case let .awaitingWinner(matchNumber):
                Text("Winner of #\(matchNumber)")
                    .foregroundStyle(focused ? .black : .primary)
            case let .awaitingLoser(matchNumber):
                Text("Loser of #\(matchNumber)")
                    .foregroundStyle(focused ? .black : .primary)
            }
            Spacer()
        }
    }

}

struct CustomButtonStyle: ButtonStyle {

    private let focused: Bool

    init(focused: Bool) {
        self.focused = focused
    }

    @ViewBuilder func makeBody(configuration: Configuration) -> some View {
//        if focused {
            configuration.label
                .padding()
                .background(focused ? .primary : .secondary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.tint))
                .scaleEffect(focused ? 1.1 : 1.0)
                .animation(.snappy, value: focused)
//        } else {
//            BorderedButtonStyle().makeBody(configuration: configuration)
//        }
    }

}
