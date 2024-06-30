import ComposableArchitecture

@Reducer public struct PickCountryFeature {

    @ObservableState public struct State {

        public let title: String

        public init(
            title: String
        ) {
            self.title = title
        }

    }

    public enum Action {

    }

    public init() { }

}
