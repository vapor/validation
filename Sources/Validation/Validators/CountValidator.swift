extension Validator where T: Collection {
    /// Validates that the data's count is within the supplied `ClosedRange`.
    ///
    ///     try validations.add(\.name, .count(5...10))
    ///
    public static func count(_ range: ClosedRange<Int>) -> Validator<T> {
        return CountValidator(min: range.lowerBound, max: range.upperBound).validator()
    }

    /// Validates that the data's count is less than the supplied upper bound using `PartialRangeThrough`.
    ///
    ///     try validations.add(\.name, .count(...10))
    ///
    public static func count(_ range: PartialRangeThrough<Int>) -> Validator<T> {
        return CountValidator(min: nil, max: range.upperBound).validator()
    }

    /// Validates that the data's count is less than the supplied lower bound using `PartialRangeFrom`.
    ///
    ///     try validations.add(\.name, .count(5...))
    ///
    public static func count(_ range: PartialRangeFrom<Int>) -> Validator<T> {
        return CountValidator(min: range.lowerBound, max: nil).validator()
    }

    /// Validates that the data's count is within the supplied `Range`.
    ///
    ///     try validations.add(\.name, .count(5..<10))
    ///
    public static func count(_ range: Range<Int>) -> Validator<T> {
        return CountValidator(min: range.lowerBound, max: range.upperBound.advanced(by: -1)).validator()
    }
}

// MARK: Private

/// Validates whether the item's count is within a supplied int range.
fileprivate struct CountValidator<T>: ValidatorType where T: Collection {
    /// See `ValidatorType`.
    var validatorReadable: String {
        let x: String
        if T.self is String.Type {
            x = "characters"
        } else {
            x = "items"
        }

        if let min = self.min, let max = self.max {
            return "between \(min) and \(max) \(x)"
        } else if let min = self.min {
            return "at least \(min) \(x)"
        } else if let max = self.max {
            return "at most \(max) \(x)"
        } else {
            return "valid"
        }
    }

    /// the minimum possible value, if nil, not checked
    /// - note: inclusive
    let min: Int?

    /// the maximum possible value, if nil, not checked
    /// - note: inclusive
    let max: Int?

    /// creates an is count validator using a partial range from
    ///     5...
    init(min: Int?, max: Int?) {
        self.min = min
        self.max = max
    }

    /// See `ValidatorType`.
    func validate(_ data: T) throws {
        if let min = self.min {
            guard data.count >= min else {
                throw BasicValidationError("is not larger than \(min)")
            }
        }

        if let max = self.max {
            guard data.count <= max else {
                throw BasicValidationError("is larger than \(max)")
            }
        }
    }
}
