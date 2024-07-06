import RootFeatureUI
import SwiftUI

@main
struct CapeBocceApp: App {

    @UIApplicationDelegateAdaptor(CapeBocceAppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            RootFeatureView(
                store: CapeBocceAppStore.shared.store
            )
            .tint(.indigo)
        }
    }

}
