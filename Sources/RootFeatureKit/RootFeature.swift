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
        case destination(PresentationAction<DestinationFeature.Action>)

    }

    @Dependency(\.defaultBracketName) var defaultBracketName
    @Dependency(\.startBracketAPIClient) var startBracketAPIClient

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
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
                    let value = try await startBracketAPIClient.start(
                        .init(
                            name: name,
                            participants: participants
                        )
                    )
                    print("Response: \(value)")
                }
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
