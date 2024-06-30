import Foundation
import SwiftUI
import UIKit

public extension Country {

    static func load() -> [Country] {
        return Locale.Region.isoRegions.compactMap { region -> Country? in
            let identifier = region.identifier

            guard
                bundleImageExists(for: identifier),
                localeNameExists(for: identifier) else {
                return nil
            }

            return Country(
                identifier: identifier
            )
        }
        .sorted(using: KeyPathComparator(\.name))
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
