/// Capable of validating validation data or throwing a validation error
public protocol Validator {
    /// Suitable for placing after `is` _and_ `is not`.
    ///
    ///     is alphanumeric
    ///     is not alphanumeric
    ///
    var validatorReadable: String { get }

    /// validates the supplied data
    func validate(_ data: ValidationData) throws
}
