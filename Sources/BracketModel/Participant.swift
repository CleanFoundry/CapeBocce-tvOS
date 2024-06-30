import Foundation

public struct Participant: Codable, Equatable, Identifiable {

    public var id: String { name }

    public var name: String

    public init(name: String) {
        self.name = name
    }

}

