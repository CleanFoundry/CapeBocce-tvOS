import DataModel
import Foundation
import IdentifiedCollections

public protocol HasRecentParticipantsState {

    var recentParticipantsData: Data? { get set }

}

public extension HasRecentParticipantsState {

    var recentParticipants: IdentifiedArrayOf<Participant> {
        get {
            guard let recentParticipantsData else { return [] }
            return try! JSONDecoder.appStoragePersistence
                .decode(IdentifiedArrayOf<Participant>.self, from: recentParticipantsData)
        } set {
            recentParticipantsData = try! JSONEncoder.appStoragePersistence
                .encode(newValue)
        }
    }

}
