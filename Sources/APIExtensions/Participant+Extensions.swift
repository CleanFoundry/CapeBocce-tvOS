import API
import CountryKit
import Foundation

public extension Participant {

    var country: Country { .init(id: countryID) }

}
