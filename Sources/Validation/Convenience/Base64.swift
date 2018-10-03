public struct Base64Validator: Validator {
    
    public init () {}

    private let pattern = "^(?:[a-z0-9\\+\\/]{4})*(?:[a-z0-9\\+\\/]{2}==|[a-z0-9\\+\\/]{3}=|[a-z0-9\\+\\/]{4})$"

    public func validate(_ input: String) throws {
        #if swift(>=4)
            let count = input.count
        #else
            let count = input.characters.count
        #endif
        guard count % 4 == 0 && input.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil else {
            throw error("\(input) is not a valid base64 string")
        }
    }

}
