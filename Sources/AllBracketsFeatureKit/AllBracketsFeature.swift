import API
import ComposableArchitecture
import Foundation

@Reducer public struct AllBracketsFeature {

    @ObservableState public struct State {
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
        case tappedBracket(Bracket)
        case tappedDeleteBracket(Bracket)
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tappedDeleteBracket(bracket):
                state.brackets.remove(bracket)
                return .none
            case .tappedBracket:
                return .none
            }
        }
    }

}
