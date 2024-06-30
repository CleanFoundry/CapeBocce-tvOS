import Foundation

public extension URL {

    static let recentParticipantsStorageURL = Self
        .cachesDirectory
        .appending(path: "recent_participants.json")

}
