import ComposableArchitecture
import CreateBracketFormFeatureKit
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
            if !store.unselectedRecentParticipants.isEmpty {
                addRecentParticipantsSection
            }
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
                    Button(
                        participant.name,
                        systemImage: participant.country.bundleAssetName
                    ) {

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

    var addRecentParticipantsSection: some View {
        Section {
            ForEach(store.unselectedRecentParticipants) { participant in
                Button {

                } label: {
                    Label {
                        Text(participant.name)
                            .font(.headline)
                    } icon: {
                        participant.country.bundleAsset
                            .resizable()
                            .frame(width: 300, height: 150, alignment: .trailing)
                            .padding()
                    }

                }
            }
        } header: {
            Text("Add Past Participants")
        }
    }

}
