struct OpenAIQuery: Encodable {

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
