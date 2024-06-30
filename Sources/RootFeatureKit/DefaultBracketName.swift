import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient struct DefaultBracketName {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    let create: () -> String

}


extension DependencyValues {

    var defaultBracketName: DefaultBracketName {
        get { self[DefaultBracketName.self] }
        set { self[DefaultBracketName.self] = newValue }
    }

}

extension DefaultBracketName: DependencyKey {

    static var liveValue: DefaultBracketName {
        DefaultBracketName(
            create: {
                @Dependency(\.date) var date
                return dateFormatter.string(from: date())
            }
        )
    }

    static var testValue = DefaultBracketName(
        create: { "Bracket Name" }
    )

}
