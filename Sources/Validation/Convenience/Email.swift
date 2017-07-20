import Foundation

public struct EmailValidator: Validator {

    public init() {}
	
	private static let name = "[a-z0-9!#$%&'*+/=?^_`{|}~]"
	private static let server = "[a-z0-9\\.-]"
	private let pattern = "^\(name)+([\\.-]?\(name)+)*@\(server)+([\\.-]?\(server)+)*(\\.\\w{2,3})+$"


    public func validate(_ input: String) throws {
    	guard input.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil else {
			throw error("\(input) is not a valid email address")
		}
    }
}