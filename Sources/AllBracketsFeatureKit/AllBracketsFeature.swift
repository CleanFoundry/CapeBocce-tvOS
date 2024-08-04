import API
import AppStoragePersistenceKit
import ComposableArchitecture
import Foundation

@Reducer public struct AllBracketsFeature {

    @ObservableState public struct State: HasBracketsState {
        @Presents public var alert: AlertState<Action.Alert>?

        @Shared(.bracketsData) public var bracketsData: Data?

        public init() { }
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
