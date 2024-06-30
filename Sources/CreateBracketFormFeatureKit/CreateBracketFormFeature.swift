import BracketModel
import ComposableArchitecture

@Reducer public struct CreateBracketFormFeature {

    @ObservableState public struct State {

        public var name: String
        public var selectedParticipants: IdentifiedArrayOf<Participant> = [
            Participant(name: "Connor"),
            Participant(name: "Kelly"),
        ]

        @Shared(.fileStorage(.recentParticipantsStorageURL))
        public var recentParticipants: IdentifiedArrayOf<Participant> = [
            Participant(name: "Connor"),
            Participant(name: "Drake"),
            Participant(name: "Kelly"),
            Participant(name: "Liam"),
        ]

        public var filteredRecentParticipants: IdentifiedArrayOf<Participant> {
            recentParticipants.filter { participant in
                !selectedParticipants.contains(participant)
            }
        }

        public init(
            name: String
        ) {
            self.name = name
        }

    }

    public enum Action: BindableAction {
        case binding(BindingAction<CreateBracketFormFeature.State>)
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        BindingReducer()
    }

}
