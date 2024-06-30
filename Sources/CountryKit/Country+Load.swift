import Foundation
import SwiftUI
import UIKit

public extension Country {

    private static var loaded: [Country]?

    static func load() -> [Country] {
        if let loaded {
            return loaded
        } else {
            let loaded = Locale.Region.isoRegions
                .compactMap { region -> Country? in
                    let identifier = region.identifier

                    guard
                        bundleImageExists(for: identifier),
                        localeNameExists(for: identifier) else {
                        return nil
                    }

                    return Country(
                        id: identifier
                    )
                }
                .sorted(using: KeyPathComparator(\.name))
            self.loaded = loaded
            return loaded
        }
    }

}

private extension Country {

    static func bundleImageExists(for identifier: String) -> Bool {
        UIImage(
            named: identifier.lowercased(),
            in: .module,
            with: nil
        ) != nil
    }

    static func localeNameExists(for identifier: String) -> Bool {
        Locale.current.localizedString(
            forRegionCode: identifier
        ) != nil
    }

}
