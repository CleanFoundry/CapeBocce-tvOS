import API
import ComposableArchitecture

@Reducer public struct BracketFeature {

    @ObservableState public struct State {

        private(set) public var bracket: Bracket

        public init(bracket: Bracket) {
            self.bracket = bracket
        }

    }

    public init() { }

}
