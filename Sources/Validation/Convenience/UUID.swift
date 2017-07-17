public enum UUIDValidator: String, Validator {

    case uuid1 = "1"
    case uuid2 = "2"
    case uuid3 = "3"
    case uuid4 = "4"
    case uuid5 = "5"
    case uuid = "[1-5]"

    private var pattern: String {
        return "^[0-9a-f]{8}-[0-9a-f]{4}-\(self.rawValue)[0-9a-f]{3}-[89abAB][0-9a-f]{3}-[0-9a-f]{12}$"
    }

    public func validate(_ input: String) throws {
        guard input.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil else {
            throw error("\(input) is not a valid \(self)")
        }
    }

}