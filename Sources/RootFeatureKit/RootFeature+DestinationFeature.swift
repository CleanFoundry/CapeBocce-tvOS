import ComposableArchitecture
import CreateBracketFormFeatureKit

extension RootFeature {

    @Reducer public enum DestinationFeature {

        case createBracket(CreateBracketFormFeature)

    }

}
