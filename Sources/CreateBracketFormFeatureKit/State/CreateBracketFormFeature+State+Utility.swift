import API
import APIExtensions
import ComposableArchitecture
import Foundation

public extension CreateBracketFormFeature.State {

    var unselectedRecentParticipants: IdentifiedArrayOf<Participant> {
        recentParticipants?.filter { participant in
            !selectedParticipants.contains(participant)
        } ?? []
    }

    var sanitizedAddParticipantName: String {
        let excluded: CharacterSet = .whitespacesAndNewlines
            .union(.illegalCharacters)
            .union(["\u{FFFC}"])
        return addNewParticipantName.trimmingCharacters(in: excluded)
    }

}
