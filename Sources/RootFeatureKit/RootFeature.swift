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

    @Dependency(\.date) var date

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tappedCreateBracket:
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                let defaultName = formatter.string(from: date())
                state.createBracketForm = .init(name: defaultName)
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
