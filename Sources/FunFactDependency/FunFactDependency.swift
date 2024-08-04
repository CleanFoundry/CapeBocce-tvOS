import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient public struct FunFactDependency {

    public var get: (_ countryName: String) async throws -> String

}

public extension DependencyValues {

    var funFact: FunFactDependency {
        get { self[FunFactDependency.self] }
        set { self[FunFactDependency.self] = newValue }
    }

}

extension FunFactDependency: DependencyKey {

    public static var liveValue: FunFactDependency {
        FunFactDependency(
            get: { countryName in
                guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
                    return "To show fun facts here, please add an OPENAI_API_KEY to the app’s environment variables."
                }
                let query = OpenAIQuery.default(countryName: countryName)
                let url = URL(string: "https://api.openai.com/v1/chat/completions")!

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = try JSONEncoder().encode(query)
                request.allHTTPHeaderFields = [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(apiKey)"
                ]

                let data = try await URLSession.shared.data(for: request)
                let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data.0)

                let firstResponse = decoded.choices.first!.message.content

                return firstResponse
            }
        )
    }

    public static var testValue = FunFactDependency()

}
