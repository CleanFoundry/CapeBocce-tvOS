import BracketModel
import ComposableArchitecture

@Reducer public struct RootFeature {

    @ObservableState public struct State {

        @Shared(.fileStorage(.bracketsStorageURL)) var brackets: IdentifiedArrayOf<Bracket> = []

        @Presents public var createBracket: CreateBracketFeature.State?

        public init() {

        }

    }

    public enum Action {

        case tappedCreateBracket
        case createBracket(PresentationAction<CreateBracketFeature.Action>)

    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tappedCreateBracket:
                state.createBracket = .init()
                return .none
            case .createBracket:
                return .none
            }
        }
        EmptyReducer()
            .ifLet(
                \.$createBracket,
                 action: \.createBracket,
                 destination: CreateBracketFeature.init
            )
    }

}
