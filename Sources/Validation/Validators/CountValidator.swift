extension Validation {
    /// Validates that the data is within the supplied `ClosedRange`.
    ///
    ///     try validations.add(\.name, .range(5...10))
    ///
    /// The validation that occurs depends on the data being validated and the generic range type:
    ///
    /// - `String`: Supports `Int`, range of character count.
    /// - `Int`: Supports `Int`, range of number.
    /// - `Double`: Supports `Double`, range of number.
    /// - `Date`: Supports `Date`, range of date.
    public static func range<T>(_ range: ClosedRange<T>) -> Validation {
        return CountValidator(min: range.lowerBound, max: range.upperBound).validation()
    }

    /// Validates that the data is less than the supplied upper bound using `PartialRangeThrough`.
    ///
    ///     try validations.add(\.name, .range(...10))
    ///
    /// The validation that occurs depends on the data being validated and the generic range type:
    ///
    /// - `String`: Supports `Int`, range of character count.
    /// - `Int`: Supports `Int`, range of number.
    /// - `Double`: Supports `Double`, range of number.
    /// - `Date`: Supports `Date`, range of date.
    public static func range<T>(_ range: PartialRangeThrough<T>) -> Validation {
        return CountValidator(min: nil, max: range.upperBound).validation()
    }

    /// Validates that the data is less than the supplied lower bound using `PartialRangeFrom`.
    ///
    ///     try validations.add(\.name, .range(5...))
    ///
    /// The validation that occurs depends on the data being validated and the generic range type:
    ///
    /// - `String`: Supports `Int`, range of character count.
    /// - `Int`: Supports `Int`, range of number.
    /// - `Double`: Supports `Double`, range of number.
    /// - `Date`: Supports `Date`, range of date.
    public static func range<T>(_ range: PartialRangeFrom<T>) -> Validation {
        return CountValidator(min: range.lowerBound, max: nil).validation()
    }

    /// Validates that the data is within the supplied `Range`.
    ///
    ///     try validations.add(\.name, .range(5..<10))
    ///
    /// The validation that occurs depends on the data being validated and the generic range type:
    ///
    /// - `String`: Supports `Int`, range of character count.
    /// - `Int`: Supports `Int`, range of number.
    /// - `Double`: Supports `Double`, range of number.
    /// - `Date`: Supports `Date`, range of date.
    public static func range<T>(_ range: Range<T>) -> Validation where T: Strideable {
        return CountValidator(min: range.lowerBound, max: range.upperBound.advanced(by: -1)).validation()
    }
}

// MARK: Private

/// Validates whether the data is within a supplied int range.
///
/// - note: strings have length checked, while integers, doubles, and dates have their values checked
fileprivate struct CountValidator<T>: Validator where T: Comparable {
    /// See `Validator`.
    var validatorReadable: String {
        if let min = self.min, let max = self.max {
            return "larger than \(min) or smaller than \(max)"
        } else if let min = self.min {
            return "larger than \(min)"
        } else if let max = self.max {
            return "smaller than \(max)"
        } else {
            return "valid"
        }
    }

    /// the minimum possible value, if nil, not checked
    /// - note: inclusive
    let min: T?

    /// the maximum possible value, if nil, not checked
    /// - note: inclusive
    let max: T?

    /// creates an is count validator using a partial range from
    ///     5...
    init(min: T?, max: T?) {
        self.min = min
        self.max = max
    }

    /// Converst a min or max value to `U`.
    func require<U>(_ value: T, as type: U.Type) throws -> U {
        guard let u = value as? U else {
            throw BasicValidationError("is not comparable to \(T.self)")
        }
        return u
    }
    
    /// See `Validator`.
    func validate(_ data: ValidationData) throws {
        switch data.storage {
        case .string(let s):
            if let min = try self.min.flatMap { try require($0, as: Int.self) } {
                guard s.count >= min else {
                    throw BasicValidationError("is not at least \(min) characters")
                }
            }

            if let max = try self.max.flatMap { try require($0, as: Int.self) } {
                guard s.count <= max else {
                    throw BasicValidationError("is more than \(max) characters")
                }
            }
        case .int(let int):
            if let min = try self.min.flatMap { try require($0, as: Int.self) } {
                guard int >= min else {
                    throw BasicValidationError("is not larger than \(min)")
                }
            }
            if let max = try self.max.flatMap { try require($0, as: Int.self) } {
                guard int <= max else {
                    throw BasicValidationError("is larger than \(max)")
                }
            }
        case .double(let double):
            if let min = try self.min.flatMap { try require($0, as: Double.self) } {
                guard double >= min else {
                    throw BasicValidationError("is not larger than \(min)")
                }
            }
            if let max = try self.max.flatMap { try require($0, as: Double.self) } {
                guard double <= max else {
                    throw BasicValidationError("is larger than \(max)")
                }
            }
        case .date(let date):
            if let earliest = try self.min.flatMap { try require($0, as: Date.self) } {
                guard date >= earliest else {
                    throw BasicValidationError("is not equal to or later than \(earliest)")
                }
            }
            if let latest = try self.max.flatMap { try require($0, as: Date.self) } {
                guard date <= latest else {
                    throw BasicValidationError("is not equal to or earlier than \(latest)")
                }
            }
            break
        default: throw BasicValidationError("is invalid")
        }
    }
}
