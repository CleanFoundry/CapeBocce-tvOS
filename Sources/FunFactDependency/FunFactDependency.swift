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
                    fatalError()
                }
                let query = Query.default(countryName: countryName)
                let url = URL(string: "https://api.openai.com/v1/chat/completions")!

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = try JSONEncoder().encode(query)
                request.allHTTPHeaderFields = [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(apiKey)"
                ]

                let data = try await URLSession.shared.data(for: request)
                let decoded = try JSONDecoder().decode(Response.self, from: data.0)

                let firstResponse = decoded.choices.first!.message.content

                return firstResponse
            }
        )
    }

    public static var testValue = FunFactDependency()

}

struct Query: Encodable {
    struct Message: Encodable {
        let role: String
        let content: String
    }

    let model: String
    let messages: [Message]

    public static func `default`(countryName: String) -> Self {
        .init(
            model: "gpt-4o-mini",
            messages: [
                .init(
                    role: "system",
                    content: "You will be provided names of countries. When given the name of a coutry, look up a fun fact about that country. The fun fact should be interesting, family friendly, and at most 1 short paragraph. Do not include any other text besides the fun fact."
                ),
                .init(
                    role: "user",
                    content: "Provide a fun fact for \(countryName)."
                )
            ]
        )
    }
}

struct Response: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
