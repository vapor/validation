/// Inverts a `Validation`.
///
///     try validations.add(\.email, .email && !.nil)
///
public prefix func ! (rhs: Validation) -> Validation {
    return NotValidator(rhs).validation()
}

// MARK: Private

/// Inverts a validator
fileprivate struct NotValidator: Validator {
    /// See `Validator`
    public var validatorReadable: String {
        return "not \(rhs.readable)"
    }

    /// The inverted `Validation`.
    let rhs: Validation

    /// Creates a new `NotValidator`.
    init(_ rhs: Validation) {
        self.rhs = rhs
    }

    /// See `Validator`
    func validate(_ data: ValidationData) throws {
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
