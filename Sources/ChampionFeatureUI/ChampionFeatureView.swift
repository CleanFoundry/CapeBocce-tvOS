import ChampionFeatureKit
import ComposableArchitecture
import ConfettiSwiftUI
import DataModel
import SwiftUI

public struct ChampionFeatureView: View {

    @Bindable private var store: StoreOf<ChampionFeature>

    public init(store: StoreOf<ChampionFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            store.participant.country.bundleAsset
                .resizable()
                .aspectRatio(contentMode: .fit)
                .containerRelativeFrame([.horizontal]) { value, _ in value / 3 }
            Text("\(store.participant.name) (\(store.participant.country.name)) won!")
                .font(.largeTitle)
            VStack(spacing: 0) {
                Spacer()
                if let funFact = store.funFact {
                    Text(funFact)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .containerRelativeFrame(.horizontal) { value, _ in 3 * value / 4 }
                } else {
                    ProgressView()
                }
                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                store.send(.didAppear)
            }
        }
        .confettiCannon(
            counter: .init(get: { store.funFact == nil ? 0 : 1 }, set: { _ in fatalError() }),
            num: 80,
            confettis: ConfettiType.allCases + [.text("🏆"), .text("🏅")],
            confettiSize: 32,
            rainHeight: 2000,
            radius: 1200,
            repetitions: 1,
            repetitionInterval: 8
        )
    }

}
