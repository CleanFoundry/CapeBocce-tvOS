import Foundation
import SwiftUI

public struct Country: Identifiable {

    public let id: String

    public init(id: String) {
        self.id = id
    }

}

public extension Country {

    var bundleAsset: Image {
        Image(
            id.lowercased(),
            bundle: .module
        )
    }

    var bundleImageResource: ImageResource {
        ImageResource(
            name: id.lowercased(),
            bundle: .module
        )
    }

    var name: String {
        Locale.current.localizedString(forRegionCode: id)!
    }

}
