import API
import APIExtensions
import BracketFeatureKit
import ComposableArchitecture
import SwiftUI

public struct BracketFeatureView: View {

    @Bindable var store: StoreOf<BracketFeature>

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
                                matchView(match: match)
                            }
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
                    .border(.red)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    func matchView(
        match: Match
    ) -> some View {
        VStack(spacing: 8) {
            participantLabel(match.participant1)
                .font(.headline)
            Text("VS")
                .font(.caption)
            participantLabel(match.participant2)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
    }

    func participantLabel(
        _ participant: MatchParticipant
    ) -> some View {
        HStack(spacing: 8) {
            switch participant {
            case let .participant(participant):
                participant.country.bundleAsset
                    .resizable()
                    .frame(width: 60, height: 40, alignment: .bottomTrailing)
                Text(participant.name)
            case let .awaitingWinner(matchNumber):
                Text("Winner of #\(matchNumber)")
            case let .awaitingLoser(matchNumber):
                Text("Loser of #\(matchNumber)")
            }
            Spacer()
        }
    }

}
