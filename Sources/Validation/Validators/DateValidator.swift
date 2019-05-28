extension Validator where T == String {
    /// Validates whether a `String` is a valid date.
    ///
    ///     try validations.add(\.createdAt, .date(formatter: dateFormatter))
    ///
    public static func date(_ dateFormatter: DateFormatter) -> Validator<T> {
        return DateValidator(dateFormatter: dateFormatter).validator()
    }
}

// MARK: Private

/// Validates whether a string is a valid date.
fileprivate struct DateValidator: ValidatorType {
    /// See `ValidatorType`.
    public var validatorReadable: String {
        return "a valid date"
    }
    
    /// the DateFormatter used to validate the string
    let dateFormatter: DateFormatter

    /// Creates a new `DateValidator`.
    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }

    /// See `Validator`.
    public func validate(_ s: String) throws {
        guard
            s.isEmpty ||
            dateFormatter.date(from: s) != nil
        else {
            throw BasicValidationError("is not a valid date")
        }
    }
}
