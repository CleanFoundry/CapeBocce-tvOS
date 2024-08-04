import API
import Foundation
import IdentifiedCollections

public protocol HasRecentParticipantsState {

    var recentParticipantsData: Data? { get set  }

}

public extension HasRecentParticipantsState {

    var recentParticipants: IdentifiedArrayOf<Participant> {
        get {
            guard let recentParticipantsData else { return [] }
            return try! JSONDecoder.api
                .decode(IdentifiedArrayOf<Participant>.self, from: recentParticipantsData)
        } set {
            recentParticipantsData = try! JSONEncoder.api.encode(newValue)
        }
    }

}
