import JSON

public struct JSONValidator: Validator {
    public typealias Input = String

    public init() {}

    public func validate(_ input: String) throws {
        do {
            _ = try JSON(bytes: input.makeBytes())
        } catch {
            throw self.error("Not a valid JSON")
        }
    }
}
