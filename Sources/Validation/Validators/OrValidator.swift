/// Combines two `Validation`s, succeeding if either of the `Validation`s does not fail.
///
///     // validate email is valid or is nil
///     try validations.add(\.email, .email || .nil)
///
public func || (lhs: Validation, rhs: Validation) -> Validation {
    return OrValidator(lhs, rhs).validation()
}

// MARK: Private

/// Combines two validators, if either is true the validation will succeed.
fileprivate struct OrValidator: Validator {
    /// See Validator.inverseMessage
    public var validatorReadable: String {
        return "\(lhs.readable) or \(rhs.readable)"
    }

    /// left validator
    let lhs: Validation

    /// right validator
    let rhs: Validation

    /// Creates a new `OrValidator`.
    init(_ lhs: Validation, _ rhs: Validation) {
        self.lhs = lhs
        self.rhs = rhs
    }

    /// See Validator.validate
    func validate(_ data: ValidationData) throws {
        do {
            try lhs.validate(data)
        } catch let left as ValidationError {
            do {
                try rhs.validate(data)
            } catch let right as ValidationError {
                throw OrValidatorError(left, right)
            }
        }
    }
}

/// Error thrown if or validation fails
fileprivate struct OrValidatorError: ValidationError {
    /// error thrown by left validator
    let left: ValidationError

    /// error thrown by right validator
    let right: ValidationError

    /// See ValidationError.reason
    var reason: String {
        var left = self.left
        left.path = self.path + self.left.path
        var right = self.right
        right.path = self.path + self.right.path
        return "\(left.reason) and \(right.reason)"
    }

    /// See ValidationError.keyPath
    var path: [String]

    /// Creates a new or validator error
    init(_ left: ValidationError, _ right: ValidationError) {
        self.left = left
        self.right = right
        self.path = []
    }
}
