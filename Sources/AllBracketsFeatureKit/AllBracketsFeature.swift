import API
import ComposableArchitecture

@Reducer public struct AllBracketsFeature {

    public struct State {
        public let brackets: IdentifiedArrayOf<Bracket>

        public init(
            brackets: IdentifiedArrayOf<Bracket>
        ) {
            self.brackets = brackets
        }
    }

    public init() { }

}
