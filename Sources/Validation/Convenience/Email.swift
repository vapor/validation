import Foundation

public struct EmailValidator: Validator {

    public init() {}
	private let pattern = "[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}"


    public func validate(_ input: String) throws {
    	guard
            let range = input.range(of: pattern, options: [.regularExpression, .caseInsensitive]),
            range.lowerBound == input.startIndex, range.upperBound == input.endIndex
        else {
			throw error("\(input) is not a valid email address")
		}
    }
}
