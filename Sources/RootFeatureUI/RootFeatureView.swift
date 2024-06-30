import SwiftUI

public struct RootFeatureView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            VStack {
                Button("Create Bracket") {

                }
                Button("View All Brackets") {

                }
            }
            .navigationTitle("Cape Bocce")
        }
    }
}

//struct RootFeatureView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootFeatureView()
//    }
//}
