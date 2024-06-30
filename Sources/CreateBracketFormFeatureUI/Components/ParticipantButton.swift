import BracketModel
import CountryKit
import SwiftUI

struct ParticipantButton<Content: View>: View {

    private let participant: Participant
    private let menuContent: () -> Content

    init(
        participant: Participant,
        @ViewBuilder menuContent: @escaping () -> Content
    ) {
        self.participant = participant
        self.menuContent = menuContent
    }

    var body: some View {
        Menu(content: menuContent) {
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
                Spacer()
            }
        }
        .listRowBackground(Color.clear)
    }
}
