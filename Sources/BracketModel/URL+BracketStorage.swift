import Foundation

public extension URL {

    static let bracketsStorageURL = Self
        .cachesDirectory
        .appending(path: "brackets.json")

}
