import API
import ComposableArchitecture
import Foundation

public extension PersistenceReaderKey where Self == AppStorageKey<Data?> {

    static var bracketsData: Self {
        .appStorage("brackets")
    }

    static var recentParticipantsData: Self {
        .appStorage("recentParticipants")
    }

}
