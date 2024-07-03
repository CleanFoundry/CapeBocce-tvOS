import AllBracketsFeatureKit
import BracketFeatureKit
import ComposableArchitecture
import CreateBracketFormFeatureKit

extension RootFeature {

    @Reducer public enum DestinationFeature {

        case allBrackets(AllBracketsFeature)
        case bracket(BracketFeature)
        case createBracket(CreateBracketFormFeature)

    }

}
