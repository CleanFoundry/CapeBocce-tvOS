import API
import ComposableArchitecture

@Reducer public struct ChampionFeature {

    @ObservableState public struct State {

        public let participant: Participant
        public var showConfetti: Bool = false

        public init(participant: Participant) {
            self.participant = participant
        }

    }

    public enum Action {
        case didAppear
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                state.showConfetti = true
                return .none
            }
        }
    }

}
