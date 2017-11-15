import Foundation

public struct EmailValidator: Validator {

    public init() {}
	private let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"


    public func validate(_ input: String) throws {
    	guard input.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil else {
			throw error("\(input) is not a valid email address")
		}
    }
}
