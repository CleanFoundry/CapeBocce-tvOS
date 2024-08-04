import API
import Foundation
import IdentifiedCollections

public protocol HasBracketsState {

    var bracketsData: Data? { get set }

}

public extension HasBracketsState {

    var brackets: IdentifiedArrayOf<Bracket> {
        get {
            guard let bracketsData else { return [] }
            return try! JSONDecoder.api
                .decode(IdentifiedArrayOf<Bracket>.self, from: bracketsData)
        } set {
            bracketsData = try! JSONEncoder.api.encode(newValue)
        }
    }

}
