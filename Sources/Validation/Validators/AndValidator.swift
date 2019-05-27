/// Combines two `Validator`s using AND logic, succeeding if both `Validator`s succeed without error.
///
///     try validations.add(\.name, .range(5...) && .alphanumeric)
///
public func &&<T> (lhs: Validator<T>, rhs: Validator<T>) -> Validator<T> {
    return AndValidator(lhs, rhs).validator()
}

/// Combines two validators, if either both succeed the validation will succeed.
fileprivate struct AndValidator<T>: ValidatorType {
    /// See `ValidatorType`.
    public var validatorReadable: String {
        return "\(lhs.readable) and is \(rhs.readable)"
    }

    /// left validator
    let lhs: Validator<T>

    /// right validator
    let rhs: Validator<T>

    /// create a new and validator
    init(_ lhs: Validator<T>, _ rhs: Validator<T>) {
        self.lhs = lhs
        self.rhs = rhs
    }

    /// See `ValidatorType`.
    func validate(_ data: T) throws {
        var left: ValidationError?
        do {
            try lhs.validate(data)
        } catch let l as ValidationError {
            left = l
        }

        var right: ValidationError?
        do {
            try rhs.validate(data)
        } catch let r as ValidationError {
            right = r
        }

        if left != nil || right != nil {
            throw AndValidatorError(left, right)
        }
    }
}

/// Error thrown if and validation fails
public struct AndValidatorError: ValidationError {
    /// error thrown by left validator
    public let left: ValidationError?

    /// error thrown by right validator
    public let right: ValidationError?

    /// See ValidationError.reason
    public var reason: String {
        if let left = left, let right = right {
            var mutableLeft = left, mutableRight = right
            mutableLeft.path = path + left.path
            mutableRight.path = path + right.path
            return "\(mutableLeft.reason) and \(mutableRight.reason)"
        } else if let left = left {
            var mutableLeft = left
            mutableLeft.path = path + left.path
            return mutableLeft.reason
        } else if let right = right {
            var mutableRight = right
            mutableRight.path = path + right.path
            return mutableRight.reason
        } else {
            return ""
        }
    }

    /// See ValidationError.keyPath
    public var path: [String]

    /// Creates a new or validator error
    init(_ left: ValidationError?, _ right: ValidationError?) {
        self.left = left
        self.right = right
        self.path = []
    }
}
