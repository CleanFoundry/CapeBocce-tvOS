import BracketModel
import ComposableArchitecture
import Foundation

@Reducer public struct RootFeature {

    @ObservableState public struct State {

        @Shared(.fileStorage(.bracketsStorageURL)) var brackets: IdentifiedArrayOf<Bracket> = []

        @Presents public var createBracketForm: CreateBracketFormFeature.State?

        public init() {

        }

    }

    public enum Action {

        case tappedCreateBracket
        case createBracketForm(PresentationAction<CreateBracketFormFeature.Action>)

    }

    @Dependency(\.defaultBracketName) var defaultBracketName

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tappedCreateBracket:
                state.createBracketForm = .init(
                    name: defaultBracketName.create()
                )
                return .none
            case .createBracketForm:
                return .none
            }
        }
        EmptyReducer()
            .ifLet(
                \.$createBracketForm,
                 action: \.createBracketForm,
                 destination: CreateBracketFormFeature.init
            )
    }

}
