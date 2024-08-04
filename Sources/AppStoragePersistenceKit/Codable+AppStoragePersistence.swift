import Foundation

public extension JSONDecoder {

    static let appStoragePersistence: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

}

public extension JSONEncoder {

    static let appStoragePersistence: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

}
