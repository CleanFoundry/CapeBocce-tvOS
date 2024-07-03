import API
import ComposableArchitecture

@Reducer public struct AllBracketsFeature {

    @ObservableState public struct State {
        public let brackets: IdentifiedArrayOf<Bracket>

        public init(
            brackets: IdentifiedArrayOf<Bracket>
        ) {
            self.brackets = brackets
        }
    }

    public enum Action {
        case tappedBracket(Bracket)
    }

    public init() { }

}
