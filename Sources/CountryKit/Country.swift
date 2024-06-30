import Foundation
import SwiftUI

public struct Country {

    public let identifier: String

    public init(identifier: String) {
        self.identifier = identifier
    }

}

public extension Country {

    var bundleAssetName: String {
        identifier.lowercased()
    }

    var bundleAsset: Image {
        Image(
            bundleAssetName,
            bundle: .module
        )
    }

    var name: String {
        Locale.current.localizedString(forRegionCode: identifier)!
    }

}
