extension Validation {
    /// Validates that the data is `nil`. Combine with the not-operator `!` to validate that the data is not `nil`.
    ///
    ///     try validations.add(\.email, .email && !.nil)
    ///
    public static var `nil`: Validation {
        return NilValidator().validation()
    }
}

// MARK: Private

/// Validates that the data is `nil`.
fileprivate struct NilValidator: Validator {
    /// See `Validator`.
    var validatorReadable: String {
        return "nil"
    }

    /// Creates a new `NilValidator`.
    init() {}

    /// See `Validator`.
    func validate(_ data: ValidationData) throws {
        switch data.storage {
        case .null: break
        default: throw BasicValidationError("is not nil")
        }
    }
}
