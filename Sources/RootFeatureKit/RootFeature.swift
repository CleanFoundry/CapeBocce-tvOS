import API
import ComposableArchitecture
import CreateBracketFormFeatureKit
import Foundation

@Reducer public struct RootFeature {

    @ObservableState public struct State {

        @Presents public var destination: DestinationFeature.State?

        public init(
            destination: DestinationFeature.State? = nil
        ) {
            self.destination = destination
        }

    }

    public enum Action {

        case tappedCreateBracket
        case tappedViewAllBrackets
        case startedBracket(Bracket)
        case loadedAllBrackets(IdentifiedArrayOf<Bracket>)
        case destination(PresentationAction<DestinationFeature.Action>)

    }

    @Dependency(\.defaultBracketName) var defaultBracketName
    @Dependency(\.startBracketAPIClient) var startBracketAPIClient
    @Dependency(\.getAllBracketsAPIClient) var getAllBracketsAPIClient

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce {
            state,
            action in
            switch action {
            case .tappedCreateBracket:
                state.destination = .createBracket(.init(
                    bracketName: defaultBracketName.create()
                ))
                return .none
            case let .destination(.presented(.createBracket(
                .tappedStartBracket(participants, name)
            ))):
                return .run { send in
                    let response = try await startBracketAPIClient.start(
                        .init(
                            name: name,
                            participants: participants
                        )
                    )
                    await send(.startedBracket(response.bracket))
                }
            case let .startedBracket(bracket):
                state.destination = .bracket(
                    .init(
                        bracket: bracket
                    )
                )
                return .none
            case .tappedViewAllBrackets:
                return .run { send in
                    let response = try await getAllBracketsAPIClient.get()
                    await send(.loadedAllBrackets(response.brackets))
                }
            case let .loadedAllBrackets(brackets):
                state.destination = .allBrackets(
                    .init(
                        brackets: brackets
                    )
                )
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(
            \.$destination,
             action: \.destination
        )
    }

}
