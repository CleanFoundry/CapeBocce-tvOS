import API
import ComposableArchitecture
import Foundation

@Reducer public struct AllBracketsFeature {

    @ObservableState public struct State {
        @Shared(.appStorage("brackets")) private var bracketsData: Data?
        private(set) public var brackets: IdentifiedArrayOf<Bracket> {
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
    }

    public init() { }

}
