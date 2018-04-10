import Debugging

/// A validation error that supports dynamic key paths.
public protocol ValidationError: Debuggable {
    /// Key path to the invalid data.
    var path: [String] { get set }
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
    /// See Debuggable.reason
    public var reason: String {
        let path: String
        if self.path.count > 0 {
            path = "`" + self.path.joined(separator: ".") + "`"
        } else {
            path = "data"
        }
        return "\(path) \(message)"
    }

    /// The validation failure
    public var message: String

    /// Key path the validation error happened at
    public var path: [String]

    /// Create a new JWT error
    public init(_ message: String) {
        self.message = message
        self.path = []
    }
}
