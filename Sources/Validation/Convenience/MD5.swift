public struct MD5Validator: Validator {

    public init () {}

    private let pattern = "^[a-f0-9]{32}$"

    public func validate(_ input: String) throws {
        guard input.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil else {
            throw error("\(input) is not a valid MD5")
        }
    }
}
