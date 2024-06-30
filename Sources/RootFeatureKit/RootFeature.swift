import BracketModel
import ComposableArchitecture

@Reducer public struct RootFeature {

    public struct State {

        @Shared(.fileStorage(.bracketsStorageURL)) var brackets: IdentifiedArrayOf<Bracket> = []

        public var createBracket: CreateBracketFeature.State?

        public init() {

        }

    }

    public init() { }

}
