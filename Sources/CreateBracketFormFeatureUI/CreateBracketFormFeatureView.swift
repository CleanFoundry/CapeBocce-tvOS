import ComposableArchitecture
import CreateBracketFormFeatureKit
import PickCountryFeatureUI
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
            addNewParticipantSection
            if !store.unselectedRecentParticipants.isEmpty {
                addRecentParticipantsSection
            }
        }
        .sheet(
            item: $store.scope(
                state: \.addNewParticipantPickCountry,
                action: \.pickCountry
            )
        ) { store in
            PickCountryFeatureView(store: store)
        }
    }

}

private extension CreateBracketFormFeatureView {

    var bracketNameSection: some View {
        Section("Bracket Name") {
            TextField("Bracket Name", text: $store.bracketName)
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
        }
    }

    var addNewParticipantSection: some View {
        Section("Add New Participant") {
            TextField("Participant Name", text: $store.addNewParticipantName)
                .onSubmit {
                    store.send(.submittedAddParticipant)
                }
            Button(
                "Add New Participant",
                systemImage: "person.badge.plus"
            ) {
                store.send(.submittedAddParticipant)
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
                    HStack(alignment: .center, spacing: 12) {
                        participant.country.bundleAsset
                            .resizable()
                            .frame(width: 300, height: 150, alignment: .trailing)
                            .shadow(radius: 18)
                            .padding()
                        VStack(alignment: .leading) {
                            Text(participant.name)
                                .font(.title)
                            Text(participant.country.name)
                        }
                    }
                }
            }
        } header: {
            Text("Add Recent Participant")
        }
    }

}
