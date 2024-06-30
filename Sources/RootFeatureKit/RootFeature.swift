import BracketModel
import ComposableArchitecture

@Reducer public struct RootFeature {

    public struct State {

        @Shared(.fileStorage(.bracketsStorageURL)) var brackets: IdentifiedArrayOf<Bracket> = []

        public init() {
        }

    }

    public init() { }

}
