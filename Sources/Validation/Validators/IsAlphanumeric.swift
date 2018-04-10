/// Validates whether a string contains only alphanumeric characters
public struct IsAlphanumeric: CharacterSetValidator {
    /// See Validator.inverseMessage
    public var validatorReadable: String {
        return "alphanumeric"
    }

    public let validatorCharacterSet: CharacterSet

    /// creates a new alphanumeric validator
    public init(whitespaces: Bool = false, newlines: Bool = false) {
        var characterSet: CharacterSet = .alphanumerics
        if whitespaces {
            characterSet = characterSet.union(.whitespaces)
        }
        if newlines {
            characterSet = characterSet.union(.newlines)
        }
        self.validatorCharacterSet = characterSet
    }
}
