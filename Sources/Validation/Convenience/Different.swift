
/// Validates that matches a given input
public struct Different<T>: Validator where T: Validatable, T: Equatable {
    /// The value expected
    public let expectation: T

    /// Initialize a validator with the expected value
    public init(_ expectation: T) {
        self.expectation = expectation
    }

    public func validate(_ input: T) throws {
        guard input != expectation else {
            throw error("\(input) does not equal expectation \(expectation)")
        }
    }
}
