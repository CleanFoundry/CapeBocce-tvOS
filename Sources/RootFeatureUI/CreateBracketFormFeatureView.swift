import ComposableArchitecture
import RootFeatureKit
import SwiftUI

public struct CreateBracketFormFeatureView: View {

    @Bindable var store: StoreOf<CreateBracketFormFeature>

    public init(store: StoreOf<CreateBracketFormFeature>) {
        self.store = store
    }

    public var body: some View {
        Form {
            bracketNameSection
            participantsSection
        }
    }

}

private extension CreateBracketFormFeatureView {

    var bracketNameSection: some View {
        Section("Bracket Name") {
            TextField("Bracket Name", text: $store.name)
        }
    }
    var participantsSection: some View {
        Section("Participants") {
            ForEach(store.recentParticipants) { participant in
                Text(participant.name)
            }
        }
    }

}
