import API
import ComposableArchitecture
import APIExtensions
import FunFactDependency

@Reducer public struct ChampionFeature {

    @ObservableState public struct State {

        public let participant: Participant
        public var funFact: String?
        public var showConfetti: Bool = false

        public init(participant: Participant) {
            self.participant = participant
        }

    }

    public enum Action {
        case didAppear
        case loadedFunFact(String)
    }

    @Dependency(\.funFact) var funFact

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadedFunFact(let funFact):
                state.funFact = funFact
                return .none
            case .didAppear:
                state.showConfetti = true
                let countryName = state.participant.country.name
                return .run { send in
                    let funFact = try await funFact.get(countryName: countryName)
                    await send(.loadedFunFact(funFact))
                }
            }
        }
    }

}
