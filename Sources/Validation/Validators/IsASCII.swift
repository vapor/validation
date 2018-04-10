import Foundation

/// Validates whether a string contains only ASCII characters
public struct IsASCII: CharacterSetValidator {
    /// See `CharacterSetValidator`.
    public var validatorCharacterSet: CharacterSet {
        return .ascii
    }

    /// Creates a new `IsASCII` validator.
    public init() { }
}

extension CharacterSet {
    /// ASCII (byte 0..<128) character set.
    fileprivate static var ascii: CharacterSet {
        var ascii: CharacterSet = .init()
        for i in 0..<128 {
            ascii.insert(Unicode.Scalar(i)!)
        }
        return ascii
    }
}
