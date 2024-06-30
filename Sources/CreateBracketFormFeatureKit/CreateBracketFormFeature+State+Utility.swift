import BracketModel
import ComposableArchitecture

public extension CreateBracketFormFeature.State {

    var unselectedRecentParticipants: IdentifiedArrayOf<Participant> {
        recentParticipants.filter { participant in
            !selectedParticipants.contains(participant)
        }
    }

}
