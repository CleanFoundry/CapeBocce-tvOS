import API
import CountryKit
import Foundation

extension Participant: Identifiable {

    public var id: String { name }

}

public extension Participant {

    var country: Country { .init(id: countryID) }

}
