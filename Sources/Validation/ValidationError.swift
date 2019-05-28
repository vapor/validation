import Debugging

/// A validation error that supports dynamic key paths. These key paths will be automatically
/// combined to support nested validations.
///
/// See `BasicValidationError` for a default implementation.
public protocol ValidationError: Debuggable {
    /// Key path to the invalid data.
    var path: [String] { get set }
    var customMessage: String? { get set }
}

extension ValidationError {
    /// See `Debuggable`.
    public var identifier: String {
        return "validationFailed"
    }
}

// MARK: Basic

/// Errors that can be thrown while working with validation
public struct BasicValidationError: ValidationError {
    /// See `Debuggable`
    public var reason: String {
        if let customMessage = customMessage {
            return customMessage
        } else {
            let path: String
            if self.path.count > 0 {
                path = "'" + self.path.joined(separator: ".") + "'"
            } else {
                path = "data"
            }
            return "\(path) \(message)"
        }
    }

    /// The validation failure
    public var message: String

    /// Key path the validation error happened at
    public var path: [String]
    
    /// See ValidationError.customMessage
    public var customMessage: String?

    /// Create a new JWT error
    public init(_ message: String) {
        self.message = message
        self.path = []
    }
}
