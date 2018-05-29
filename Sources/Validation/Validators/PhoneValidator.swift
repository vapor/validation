
public enum PhoneFormat {
    /// Example: `2397777777`
    case plain
    /// Example: `(239)777-7777`
    case dashWithParenthesis
    /// Example: `239-777-7777`
    case dashOnly

    var regex: String {
        switch self {
        case .plain:
            return simpleRegex
        case .dashWithParenthesis:
            return parenthesisWithDashRegex
        case .dashOnly:
            return onlyDashRegex
        }
    }
}

// MARK: PhoneFormat Regex
private extension PhoneFormat {

    var simpleRegex: String {
        return "[0-9]{3}[0-9]{3}[0-9]{4}$"
    }

    var parenthesisWithDashRegex: String {
        return "\\([0-9]{3}\\)[0-9]{3}-[0-9]{4}$"
    }

    var onlyDashRegex: String {
        return "[0-9]{3}-[0-9]{3}-[0-9]{4}$"
    }
}

public enum PhoneType {
    /// +1 `PhoneFormat`
    case prefix(PhoneFormat)
    /// `PhoneFormat`
    case simple(PhoneFormat)

    var regex: String {
        switch self {
        case .prefix(let format):
            return format == .dashOnly ?
                "\(prefixRegex)-\(format.regex)" : "\(prefixRegex)\(format.regex)"
        case .simple(let format):
            return format.regex
        }
    }
}

private extension PhoneType {

    var prefixRegex: String {
        return "[0-9]{1,4}"
    }
}

public extension Validator where T == String {
    /// Validates whether a `String` is a valid phone format.
    public static func phone(type: PhoneType) -> Validator<T> {
        return PhoneValidator(type: type).validator()
    }
}

private struct PhoneValidator: ValidatorType {

    let type: PhoneType

    public var validatorReadable: String {
        return "a valid phone number"
    }

    /// Validates phone format as follows (123)456-7890
    public func validate(_ s: String) throws {
        guard let range = s.range(of: type.regex, options: [.regularExpression, .caseInsensitive]),
            range.lowerBound == s.startIndex && range.upperBound == s.endIndex
            else {
                throw BasicValidationError("is not a valid phone format")
        }
    }
}
