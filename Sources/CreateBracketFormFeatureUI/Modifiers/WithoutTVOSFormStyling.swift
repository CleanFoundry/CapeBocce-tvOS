import SwiftUI

struct WithoutTVOSFormStylingModifier: ViewModifier {

    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
        .listRowBackground(Color.clear)
    }

}

extension View {

    func withoutTVOSFormStyling() -> some View {
        modifier(WithoutTVOSFormStylingModifier())
    }

}
