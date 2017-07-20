public struct ASCIIValidator: Validator {
    
    public init () {}

    private let pattern = "^[ -~]+$"

    public func validate(_ input: String) throws {
        guard input.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil else {
            throw error("\(input) is not valid ascii")
        }
    }

}
