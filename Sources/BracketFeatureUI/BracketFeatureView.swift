import API
import APIExtensions
import BracketFeatureKit
import ChampionFeatureUI
import ConfettiSwiftUI
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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    store.send(.didAppear)
                }
            }
            .confettiCannon(
                counter: .init(get: { store.showConfetti ? 1 : 0 }, set: { _ in fatalError() }),
                num: 80,
                confettis: ConfettiType.allCases + [.text("🏆"), .text("🏅")],
                confettiSize: 32,
                rainHeight: 2000,
                radius: 1200,
                repetitions: 100,
                repetitionInterval: 8
            )
            .sheet(
                item: $store.scope(
                    state: \.champion,
                    action: \.champion
                )) { store in
                    ChampionFeatureView(store: store)
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
                    loserBracketEdgeCaseSpacing(matches)
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

    @ViewBuilder func loserBracketEdgeCaseSpacing(
        _ matches: [Match]
    ) -> some View {
        let firstMatch = matches.first!
        let needsExtraSpacing = firstMatch.kind != .default && firstMatch.heightScaleFactor == 1
        Spacer().frame(height: needsExtraSpacing ? 60 : 24)
    }

}
