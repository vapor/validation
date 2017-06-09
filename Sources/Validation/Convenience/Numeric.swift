public struct Numeric: Validator {

    public typealias Input = String

    public func validate(_ input: String) throws {
        guard Double(input) != nil else {
            throw error("Not numeric")
        }
    }
}
