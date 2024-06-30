import BracketModel
import CountryKit
import SwiftUI

struct ParticipantButton: View {

    private let participant: Participant
    private let action: () -> Void

    init(
        participant: Participant,
        action: @escaping () -> Void
    ) {
        self.participant = participant
        self.action = action
    }

    var body: some View {
        Button(
            action: action
        ) {
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
}
