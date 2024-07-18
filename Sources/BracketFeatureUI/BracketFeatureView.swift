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
                        MatchButtonView(
                            match: match,
                            allMatches: store.matches
                        ) { winner in
                            store.send(.tappedParticipantWon(winner, match, store.bracketName))
                        }
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

}
