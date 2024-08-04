import DataModel
import Foundation
import IdentifiedCollections

public protocol HasBracketsState {

    var bracketsData: Data? { get set }

}

public extension HasBracketsState {

    var brackets: IdentifiedArrayOf<Bracket> {
        get {
            guard let bracketsData else { return [] }
            return try! JSONDecoder.appStoragePersistence
                .decode(IdentifiedArrayOf<Bracket>.self, from: bracketsData)
        } set {
            bracketsData = try! JSONEncoder.appStoragePersistence
                .encode(newValue)
        }
    }

}
