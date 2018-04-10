public protocol CharacterSetValidator: Validator {
    var validatorCharacterSet: CharacterSet { get }
}

extension CharacterSetValidator {
    /// See `Validator`
    public var validatorReadable: String {
        if validatorCharacterSet.traits.count > 0 {
            let string = validatorCharacterSet.traits.joined(separator: ", ")
            return "in \(string)"
        } else {
            return "in required character set"
        }
    }

    /// See `CharacterSetValidator`
    public func validate(_ data: ValidationData) throws {
        switch data {
        case .string(let s):
            if let range = s.rangeOfCharacter(from: validatorCharacterSet.inverted) {
                var reason = "contains an invalid character: '\(s[range])'"
                if validatorCharacterSet.traits.count > 0 {
                    let string = validatorCharacterSet.traits.joined(separator: ", ")
                    reason += " (allowed: \(string))"
                }
                throw BasicValidationError(reason)
            }
        default: throw BasicValidationError("is not a string")
        }
    }
}

extension CharacterSet {
    fileprivate var traits: [String] {
        var desc: [String] = []
        if isSuperset(of: .newlines) {
            desc.append("newlines")
        }
        if isSuperset(of: .whitespaces) {
            desc.append("whitespace")
        }
        if isSuperset(of: .capitalizedLetters) {
            desc.append("A-Z")
        }
        if isSuperset(of: .lowercaseLetters) {
            desc.append("a-z")
        }
        if isSuperset(of: .decimalDigits) {
            desc.append("0-9")
        }
        print(desc)
        return desc
    }
}
