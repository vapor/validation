/// Inverts a `Validation`.
///
///     try validations.add(\.email, .email && !.nil)
///
public prefix func !<T> (rhs: Validator<T>) -> Validator<T> {
    return NotValidator(rhs).validator()
}

// MARK: Private

/// Inverts a validator
fileprivate struct NotValidator<T>: ValidatorType {
    /// See `ValidatorType`.
    typealias ValidationData = T

    /// See `ValidatorType`
    public var validatorReadable: String {
        return "not \(rhs.readable)"
    }

    /// The inverted `Validator`.
    let rhs: Validator<T>

    /// Creates a new `NotValidator`.
    init(_ rhs: Validator<T>) {
        self.rhs = rhs
    }

    /// See `ValidatorType`
    func validate(_ data: T) throws {
        var error: ValidationError?
        do {
            try rhs.validate(data)
        } catch let e as ValidationError {
            error = e
        }
        guard error != nil else {
            throw BasicValidationError("is \(rhs.readable)")
        }
    }
}
