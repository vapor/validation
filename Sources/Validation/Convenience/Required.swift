import Node

public struct Required: Validator {
    public typealias Input = Node?

    public init() {}

    public func validate(_ input: Node?) throws {
        guard let input = input else {
            throw error("The value is null.")
        }

        if let string = input.string {
            guard !string.isEmpty else {
                throw error("The value is an empty string.")
            }
        }

        if let array = input.array {
            guard array.count > 0 else {
                throw error("The value is an empty array.")
            }
        }
    }
}

extension Optional: Validatable {}
