public struct MongoIDValidator: Validator {

    public init() {}

    private let pattern = "^[a-f0-9]{24}$"
    
    public func validate(_ input: String) throws {
        guard input.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil else {
            throw error("\(input) is not a valid mongo Id")
        }
    }

}