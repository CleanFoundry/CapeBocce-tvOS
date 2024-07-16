import API
import ComposableArchitecture
import Foundation

@Reducer public struct AllBracketsFeature {

    @ObservableState public struct State {

        @Presents public var alert: AlertState<Action.Alert>?

        @Shared(.appStorage("brackets")) private var bracketsData: Data?
        public var brackets: IdentifiedArrayOf<Bracket> {
            get {
                guard let bracketsData else { return [] }
                return try! JSONDecoder.api
                    .decode(IdentifiedArrayOf<Bracket>.self, from: bracketsData)
            } set {
                bracketsData = try! JSONEncoder.api.encode(newValue)
            }
        }

        public init() {
        }
    }

    public enum Action {
        public enum Alert {
            case confirmedDelete(Bracket)
        }
        case alert(PresentationAction<Alert>)
        case tappedBracket(Bracket)
        case tappedDeleteBracket(Bracket)
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tappedDeleteBracket(bracket):
                state.alert = .init(
                    title: { TextState("Confirmation") },
                    actions: {
                        ButtonState.cancel(TextState("Cancel"))
                        ButtonState.destructive(
                            TextState("Confirm"),
                            action: .send(
                                .confirmedDelete(bracket),
                                animation: .snappy
                            )
                        )
                    },
                    message: { TextState("Delete the bracket \"\(bracket.name)\"?") }
                )
                return .none
            case .tappedBracket:
                return .none
            case let .alert(.presented(.confirmedDelete(bracket))):
                state.brackets.remove(bracket)
                return .none
            case .alert:
                return .none
            }
        }
        .ifLet(\.alert, action: \.alert)
    }

}
