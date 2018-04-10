/// Capable of being validated.
///
///     final class User: Validatable, Reflectable {
///         var id: Int?
///         var name: String
///         var age: Int
///
///         init(id: Int? = nil, name: String, age: Int) {
///             self.id = id
///             self.name = name
///             self.age = age
///         }
///
///         static var validations: Validations = [
///             key(\.name): IsCount(5...) && IsAlphanumeric(), // Is at least 5 letters and alphanumeric
///             key(\.age): IsCount(18...) // 18 or older
///         ]
///     }
///
public protocol Validatable {
    /// The validations that will run when `.validate()` is called on an instance of this class.
    static var validations: Validations { get }
}

extension Validatable {
    /// Validates the model, throwing an error if any of the validations fail.
    /// - note: non-validation errors may also be thrown should the validators encounter unexpected errors.
    public func validate() throws {
        var errors: [ValidationError] = []

        for (key, validation) in Self.validations.storage {
            /// fetch the value for the key path and
            /// convert it to validation data
            let data = try getValidationData(at: key)

            /// run the validation, catching validation errors
            do {
                try validation.validate(data)
            } catch var error as ValidationError {
                error.path += key.path
                errors.append(error)
            }
        }

        if !errors.isEmpty {
            throw ValidateError(errors)
        }
    }
}

// MARK: Private

/// a collection of errors thrown by validatable models validations
fileprivate struct ValidateError: ValidationError {
    /// the errors thrown
    var errors: [ValidationError]

    /// See ValidationError.keyPath
    var path: [String]

    /// See ValidationError.reason
    var reason: String {
        return errors.map { error in
            var mutableError = error
            mutableError.path = path + error.path
            return mutableError.reason
        }.joined(separator: ", ")
    }

    /// creates a new validatable error
    init(_ errors: [ValidationError]) {
        self.errors = errors
        self.path = []
    }
}
