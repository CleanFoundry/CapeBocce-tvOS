import SwiftUI

public struct Country {

    public let name: String
    public let localeIdentifier: String

    public var bundleAsset: Image {
        Image(
            localeIdentifier,
            bundle: .module
        )
    }

}
