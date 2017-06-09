private let regex = "^.*(?=.{3,})(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\\d\\X])(?=.*[^a-zA-Z\\d\\s:]).*$"

/*The password contains characters from at least three of the following four categories:

 English uppercase characters (A – Z)
 English lowercase characters (a – z)
 Base 10 digits (0 – 9)
 Non-alphanumeric (For example: !, $, #, or %)
 Unicode characters
 */

public struct StrongPassword: Validator {
    internal let minLength: Int

    public init(minLength: Int = 6) {
        self.minLength = minLength
    }

    public func validate(_ input: String) throws {
        guard
            input.range(of: regex, options: .regularExpression) != nil
                && input.count >= minLength
            else {
                throw error("Not a strong password")
        }
    }
}
