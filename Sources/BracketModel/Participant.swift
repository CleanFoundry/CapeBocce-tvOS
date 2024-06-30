import CountryKit
import Foundation

public struct Participant: Codable, Equatable, Identifiable {

    public var id: String { name }

    public var name: String
    public var countryID: String

    public var country: Country { .init(id: countryID) }

    public init(
        name: String,
        countryID: String
    ) {
        self.name = name
        self.countryID = countryID
    }

}
