import API
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
        NavigationStack {
            Form {
                bracketNameSection
                participantsSection
                addNewParticipantSection
                if let recentParticipants = store.unselectedRecentParticipants {
                    if !recentParticipants.isEmpty {
                        addRecentParticipantsSection(participants: recentParticipants)
                    }
                    startButton
                } else {
                    ProgressView()
                        .withoutTVOSFormStyling()
                }
            }
            .navigationTitle("Create Bracket")
            .sheet(
                item: $store.scope(
                    state: \.pickCountry,
                    action: \.pickCountry
                )
            ) { store in
                PickCountryFeatureView(store: store)
            }
        }
        .task {
            store.send(.didAppear)
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
        Section("Participants (\(store.selectedParticipants.count))") {
            if store.selectedParticipants.isEmpty {
                ContentUnavailableView(
                    "No participants yet",
                    systemImage: "person.3"
                )
                .withoutTVOSFormStyling()
            } else {
                ForEach(store.selectedParticipants) { participant in
                    ParticipantButton(participant: participant) {
                        Button("Update country", systemImage: "globe.europe.africa") {
                            store.send(.tappedUpdateCountry(participant))
                        }
                        Button("Remove from bracket", systemImage: "minus.circle") {
                            store.send(.removedParticipant(participant))
                        }
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

    func addRecentParticipantsSection(
        participants: IdentifiedArrayOf<Participant>
    ) -> some View {
        Section {
            ForEach(participants) { participant in
                ParticipantButton(participant: participant) {
                    Button("Add to bracket", systemImage: "plus.circle") {
                        store.send(.addedRecentParticipant(participant))
                    }
                    Button("Update country & add to bracket", systemImage: "globe.americas") {
                        store.send(.tappedUpdateCountry(participant))
                    }
                    Button("Delete participant", systemImage: "trash", role: .destructive) {
                        store.send(.tappedDeleteParticipant(participant))
                    }
                }
            }
            Button(
                "Add All Recent Participants",
                systemImage: "person.3"
            ) {
                store.send(.tappedAddAllRecentParticipants)
            }
            .buttonStyle(.borderedProminent)
            .withoutTVOSFormStyling()
        } header: {
            Text("Add Recent Participant")
        }
    }

    var startButton: some View {
        Button(
            "Start Bracket",
            systemImage: "figure.bowling"
        ) {
            store.send(.tappedStartBracket)
        }
        .font(.title)
        .buttonStyle(.borderedProminent)
        .withoutTVOSFormStyling()
    }

}
