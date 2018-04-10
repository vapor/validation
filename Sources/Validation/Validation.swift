/// A discrete validation. Usually created by calling `Validator.validation()`.
///
/// All validation operators (`&&`, `||`, `!`, etc) work on `Validation`.
///
///     try validations.add(\.firstName, .count(5...) && .alphanumeric)
///
/// Adding static properties to this type will enable leading-dot syntax when constructing validations.
///
///     extension Validation {
///         static var myValidation: Validation { return MyValidator().validation() } 
///     }
///
public struct Validation {
    /// Suitable for placing after `is` _and_ `is not`.
    ///
    ///     is alphanumeric
    ///     is not alphanumeric
    ///
    public var readable: String

    /// Validates the supplied `ValidationData`, throwing an error if it is not valid.
    ///
    /// - parameters:
    ///     - data: `ValidationData` to validate.
    /// - throws: `ValidationError` if the data is not valid, or another error if something fails.
    public var validate: (ValidationData) throws -> Void

    /// Creates a new `Validation`.
    ///
    /// - parameters:
    ///     - readable: Readable name, suitable for placing after `is` _and_ `is not`.
    ///     - validate: Validates the supplied `ValidationData`, throwing an error if it is not valid.
    public init(_ readable: String, _ validate: @escaping (ValidationData) throws -> Void) {
        self.readable = readable
        self.validate = validate
    }
}
