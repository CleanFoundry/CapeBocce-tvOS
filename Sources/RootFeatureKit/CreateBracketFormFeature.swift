import BracketModel
import ComposableArchitecture

@Reducer public struct CreateBracketFormFeature {

    @ObservableState public struct State {

        public var name: String

        @Shared(.fileStorage(.recentParticipantsStorageURL))
        public var recentParticipants: IdentifiedArrayOf<Participant> = []

        public init(
            name: String
        ) {
            self.name = name
        }

    }

    public enum Action: BindableAction {
        case binding(BindingAction<CreateBracketFormFeature.State>)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
    }

}
