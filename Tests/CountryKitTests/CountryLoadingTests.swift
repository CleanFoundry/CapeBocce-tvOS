import CountryKit
import SnapshotTesting
import XCTest

final class CountryLoadingTests: XCTestCase {

    func testLoadedCountries() {
        let countries = Country.load()
        assertSnapshot(of: countries, as: .dump, record: true)
    }

}
