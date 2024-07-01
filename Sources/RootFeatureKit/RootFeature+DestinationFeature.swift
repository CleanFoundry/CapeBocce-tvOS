import BracketFeatureKit
import ComposableArchitecture
import CreateBracketFormFeatureKit

extension RootFeature {

    @Reducer public enum DestinationFeature {

        case bracket(BracketFeature)
        case createBracket(CreateBracketFormFeature)

    }

}
