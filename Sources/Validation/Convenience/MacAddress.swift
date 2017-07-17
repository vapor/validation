public struct MacAddressValidator: Validator {

    public init () {}

    private let pattern = "^([a-f0-9]{2}([:-]?[a-f0-9]{2}){5}|[a-f0-9]{4}(\\.?[a-f0-9]{4}){2})$"

    public func validate(_ input: String) throws {
        guard input.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil else {
            throw error("\(input) is not a valid mac address")
        }
    }

}