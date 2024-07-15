import SwiftUI

struct MatchButtonStyle: ButtonStyle {

    private let focused: Bool

    init(focused: Bool) {
        self.focused = focused
    }

    @ViewBuilder func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(focused ? .secondary : .tertiary)
                    .strokeBorder(.tint, lineWidth: focused ? 4 : 0)
            )
            .scaleEffect(focused ? 1.2 : 1.0)
            .animation(.snappy, value: focused)
    }

}
