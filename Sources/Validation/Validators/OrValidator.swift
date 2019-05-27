/// Combines two `Validator`s, succeeding if either of the `Validator`s does not fail.
///
///     // validate email is valid or is nil
///     try validations.add(\.email, .email || .nil)
///
public func ||<T> (lhs: Validator<T>, rhs: Validator<T>) -> Validator<T> {
    return OrValidator(lhs, rhs).validator()
}

// MARK: Private

/// Combines two validators, if either is true the validation will succeed.
fileprivate struct OrValidator<T>: ValidatorType {
    /// See Validator.inverseMessage
    public var validatorReadable: String {
        return "\(lhs.readable) or is \(rhs.readable)"
    }

    /// left validator
    let lhs: Validator<T>

    /// right validator
    let rhs: Validator<T>

    /// Creates a new `OrValidator`.
    init(_ lhs: Validator<T>, _ rhs: Validator<T>) {
        self.lhs = lhs
        self.rhs = rhs
    }

    /// See Validator.validate
    func validate(_ data: T) throws {
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
public struct OrValidatorError: ValidationError {
    /// error thrown by left validator
    public let left: ValidationError

    /// error thrown by right validator
    public let right: ValidationError

    /// See ValidationError.reason
    public var reason: String {
        var left = self.left
        left.path = self.path + self.left.path
        var right = self.right
        right.path = self.path + self.right.path
        return "\(left.reason) and \(right.reason)"
    }

    /// See ValidationError.keyPath
    public var path: [String]

    /// Creates a new or validator error
    init(_ left: ValidationError, _ right: ValidationError) {
        self.left = left
        self.right = right
        self.path = []
    }
}
