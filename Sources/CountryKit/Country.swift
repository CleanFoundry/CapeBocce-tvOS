import Foundation
import SwiftUI

public struct Country {

    public let identifier: String

    public var bundleAsset: Image {
        Image(
            identifier.lowercased(),
            bundle: .module
        )
    }

    public var name: String {
        Locale.current.localizedString(forRegionCode: identifier)!
    }

}
