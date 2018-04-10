/// Capable of being validated.
///
///     struct User: Validatable, Reflectable {
///         var name: String
///         var age: Int
///
///         static func validations() throws -> Validations<User> {
///             var validations = Validations(User.self)
///             // validate name is at least 5 characters and alphanumeric
///             try validations.add(\.name, .count(5...) && .alphanumeric)
///             // validate age is 18 or older
///             try validations.add(\.age, .count(18...))
///             return validations
///         }
///     }
///
public protocol Validatable {
    /// The validations that will run when `.validate()` is called on an instance of this class.
    ///
    ///     struct User: Validatable, Reflectable {
    ///         var name: String
    ///         var age: Int
    ///
    ///         static func validations() throws -> Validations<User> {
    ///             var validations = Validations(User.self)
    ///             // validate name is at least 5 characters and alphanumeric
    ///             try validations.add(\.name, .count(5...) && .alphanumeric)
    ///             // validate age is 18 or older
    ///             try validations.add(\.age, .count(18...))
    ///             return validations
    ///         }
    ///     }
    ///
    static func validations() throws -> Validations<Self>
}

extension Validatable {
    /// Validates the model, throwing an error if any of the validations fail.
    ///
    ///     let user = User(name: "Vapor", age: 3)
    ///     try user.validate()
    ///
    /// - note: Non-validation errors may also be thrown should the validators encounter unexpected errors.
    public func validate() throws {
        var errors: [ValidationError] = []

        let validations = try Self.validations()
        for (key, validation) in validations {
            /// fetch the value for the key path and
            /// convert it to validation data
            let data = try key.get(from: self)

            /// run the validation, catching validation errors
            do {
                try validation.validate(data)
            } catch var error as ValidationError {
                error.path += key.path
                errors.append(error)
            }
        }

        if !errors.isEmpty {
            throw ValidateErrors(errors)
        }
    }
}

/// A collection of errors thrown by validatable models validations
fileprivate struct ValidateErrors: ValidationError {
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
