import Foundation
import SwiftUI
import UIKit

public extension Country {

    static func load() -> [Country] {
        let ids = Locale.Region.isoRegions

        return ids.compactMap { id -> Country? in
            let sanitizedIdentifier = id.identifier.lowercased()

            guard bundleImageExists(for: sanitizedIdentifier) else {
                return nil
            }

            guard let name = Locale.current.localizedString(
                forRegionCode: id.identifier
            ) else {
                return nil
            }

            return Country(
                name: name,
                localeIdentifier: sanitizedIdentifier
            )
        }
        .sorted(using: KeyPathComparator(\.name))
    }

}

private extension Country {

    static func bundleImageExists(for sanitizedIdentifier: String) -> Bool {
        UIImage(named: sanitizedIdentifier, in: .module, with: nil) != nil
    }

}
