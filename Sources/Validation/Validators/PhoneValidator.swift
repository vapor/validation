
/// Describes the validation of the area code and the digits after the area code.
/// Supports the following types:
/// - **plain**: Only uses numbers. Example: `2397777777`
/// - **dashWithParenthesis**: Uses Dash and Parenthesis. Example: `(239)777-7777`
/// - **dashOnly**: Only uses Dashes. Example: `239-777-7777`
public enum PhoneFormat {
    /// Only uses numbers. Example: `2397777777`
    case plain
    /// Uses Dash and Parenthesis. Example: `(239)777-7777`
    case dashWithParenthesis
    /// Only uses Dashes. Example: `239-777-7777`
    case dashOnly

    var regex: String {
        switch self {
        case .plain:
            return plainRegex
        case .dashWithParenthesis:
            return dashWithParenthesisRegex
        case .dashOnly:
            return onlyDashRegex
        }
    }
}

// MARK: PhoneFormat Regex
private extension PhoneFormat {

    var plainRegex: String {
        return "[0-9]{3}[0-9]{3}[0-9]{4}$"
    }

    var dashWithParenthesisRegex: String {
        return "\\([0-9]{3}\\)[0-9]{3}-[0-9]{4}$"
    }

    var onlyDashRegex: String {
        return "[0-9]{3}-[0-9]{3}-[0-9]{4}$"
    }
}

/// Describes the phone type to validate against.
/// This doesn't take into consideration the area code or the digits after the area code (**1** (xxx)xxx-xxxx). The validation for these is set by `PhoneFormat`.
/// Supports the following types:
/// - **useCountryCode**: Will validate that the phone number have the country code `1 (xxx)xxx-xxxx`
/// - **useSimple**: Only validates the area code and phone number.
/// - **useCustomRegex**: Will validate against a custom regex passed in as a parameter. This option should be use when validating phone numbers that don't follow USA/Canada standards. (i.e. Australia, China, etc...)
public enum PhoneType {

    public typealias CustomRegex = () -> String
    /// Uses country code and always adds an empty space after. Example: `1 (239)555-7777`. Follows USA/Canada standards.
    case useCountryCode(PhoneFormat)
    /// `PhoneFormat`
    case useSimple(PhoneFormat)
    /// Use a custom regex for phone numbers that don't follow USA/Canada standards. (i.e. Australia, China, etc...)
    case useCustomRegex(CustomRegex)

    var regex: String {
        switch self {
        case .useCountryCode(let format):
            return "\(countryCodeRegex) \(format.regex)"
        case .useSimple(let format):
            return format.regex
        case .useCustomRegex(let customRegex):
            return customRegex()
        }
    }
}

private extension PhoneType {

    var countryCodeRegex: String {
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
