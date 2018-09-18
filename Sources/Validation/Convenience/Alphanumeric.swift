private let alphanumeric = "abcdefghijklmnopqrstuvwxyz0123456789"
#if swift(>=4)
private let validCharacters = alphanumeric
#else
private let validCharacters = alphanumeric.characters
#endif

/// A validator that can be used to check that a
/// given string contains only alphanumeric characters
public struct OnlyAlphanumeric: Validator {
    public init() {}
    /**
        Validate whether or not an input string contains only
        alphanumeric characters. a...z0...9

        - parameter value: input value to validate

        - throws: an error if validation fails
    */


    public func validate(_ input: String) throws {

    #if swift(>=4)
        let characters = input.lowercased()
    #else
        let characters = input.lowercased().characters
    #endif

        let passed = !characters
            .contains { !validCharacters.contains($0) }

        if !passed {
            throw error("\(input) is not alphanumeric")
        }
    }
}
