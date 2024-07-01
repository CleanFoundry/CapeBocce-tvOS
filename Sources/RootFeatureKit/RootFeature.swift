import API
import ComposableArchitecture
import CreateBracketFormFeatureKit
import Foundation

@Reducer public struct RootFeature {

    @ObservableState public struct State {

        @Presents public var createBracketForm: CreateBracketFormFeature.State?

        public init(
            createBracketForm: CreateBracketFormFeature.State? = nil
        ) {
            self.createBracketForm = createBracketForm
        }

    }

    public enum Action {

        case tappedCreateBracket
        case createBracketForm(PresentationAction<CreateBracketFormFeature.Action>)

    }

    @Dependency(\.defaultBracketName) var defaultBracketName

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tappedCreateBracket:
                state.createBracketForm = .init(
                    bracketName: defaultBracketName.create()
                )
                return .none
            case .createBracketForm:
                return .none
            }
        }
        .ifLet(
            \.$createBracketForm,
             action: \.createBracketForm,
             destination: CreateBracketFormFeature.init
        )
    }

}
