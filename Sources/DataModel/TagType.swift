import Tagged

public enum TagType {
    public enum MatchNumber { }
    public enum ParticipantName { }
    public enum Round { }
}
public typealias MatchNumber = Tagged<TagType.MatchNumber, Int>
public typealias ParticipantName = Tagged<TagType.ParticipantName, String>
public typealias Round = Tagged<TagType.Round, Int>
