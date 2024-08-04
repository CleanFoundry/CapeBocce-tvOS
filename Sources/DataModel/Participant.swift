import CountryKit
import Tagged

public struct Participant: Codable, Equatable, Identifiable, Hashable {

    public let name: ParticipantName
    public var id: ParticipantName { name }

    public var countryID: String

    public init(name: ParticipantName, countryID: String) {
        self.name = name
        self.countryID = countryID
    }

}

public extension Participant {

    var country: Country { .init(id: countryID) }

}
