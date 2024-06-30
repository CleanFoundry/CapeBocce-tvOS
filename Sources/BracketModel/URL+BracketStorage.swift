import Foundation

public extension URL {

    static let bracketsStorageURL = Self
        .cachesDirectory
        .appending(path: "brackets.json")

    static let recentParticipantsStorageURL = Self
        .cachesDirectory
        .appending(path: "recent_participants.json")

}
