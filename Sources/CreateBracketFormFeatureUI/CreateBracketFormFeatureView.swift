import ComposableArchitecture
import CreateBracketFormFeatureKit
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
            addPastParticipantsSection
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
            if store.selectedParticipants.isEmpty {
                ContentUnavailableView(
                    "No participants yet",
                    systemImage: "person.3"
                )
                .withoutTVOSFormStyling()
            } else {
                ForEach(store.selectedParticipants) { participant in
                    Button(participant.name) {

                    }
                }
            }
            Button(
                "Add New Participant",
                systemImage: "person.badge.plus"
            ) {
            }
            .buttonStyle(.borderedProminent)
            .withoutTVOSFormStyling()
        }
    }

    var addPastParticipantsSection: some View {
        Section {
            ForEach(store.filteredRecentParticipants) { participant in
                Button(participant.name) {

                }
            }
        } header: {
            Text("Add Past Participants")
        }
    }

}
