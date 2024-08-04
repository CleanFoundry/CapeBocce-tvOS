import Foundation
import IdentifiedCollections
import Tagged

public struct Bracket: Codable, Equatable, Identifiable {

    public enum TagType {
        public enum Name { }
    }
    public typealias Name = Tagged<TagType.Name, String>
    public let name: Name
    public var id: Name { name }

    public let createdAt: Date

    public var matches: IdentifiedArrayOf<Match>

    public var champion: Participant?

    public init(
        name: Name,
        createdAt: Date,
        matches: IdentifiedArrayOf<Match>,
        champion: Participant? = nil
    ) {
        self.name = name
        self.createdAt = createdAt
        self.matches = matches
        self.champion = champion
    }

}
