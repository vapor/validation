import Foundation

/// Validates whether a string is a valid email address
public struct IsEmail: Validator {
    /// See Validator.inverseMessage
    public var validatorReadable: String {
        return "valid email address"
    }

    /// creates a new ASCII validator
    public init() {}

    /// See Validator.validate
    public func validate(_ data: ValidationData) throws {
        switch data {
        case .string(let s):
            guard
                let range = s.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: [.regularExpression, .caseInsensitive]),
                range.lowerBound == s.startIndex && range.upperBound == s.endIndex
            else {
                throw BasicValidationError("is not a valid email address")
            }
        default:
            throw BasicValidationError("is not a string")
        }
    }
}
