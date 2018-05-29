import Core
import Validation
import XCTest

class ValidationTests: XCTestCase {
    func testValidate() throws {
        let user = User(name: "Tanner", age: 23, pet: Pet(name: "Zizek Pulaski", age: 4), phone:"1 (239)999-7575")
        user.luckyNumber = 7
        user.email = "tanner@vapor.codes"
        try user.validate()
        try user.pet.validate()
    }

    func testASCII() throws {
        try Validator<String>.ascii.validate("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        try Validator<String>.ascii.validate("\n\r\t")
        XCTAssertThrowsError(try Validator<String>.ascii.validate("\n\r\t\u{129}"))
        try Validator<String>.ascii.validate(" !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~")
        XCTAssertThrowsError(try Validator<String>.ascii.validate("ABCDEFGHIJKLMNOPQR🤠STUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"))
    }

    func testAlphanumeric() throws {
        try Validator<String>.alphanumeric.validate("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        XCTAssertThrowsError(try Validator<String>.alphanumeric.validate("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"))
    }

    func testEmail() throws {
        try Validator<String>.email.validate("tanner@vapor.codes")
        XCTAssertThrowsError(try Validator<String>.email.validate("tanner@vapor.codestanner@vapor.codes"))
        XCTAssertThrowsError(try Validator<String>.email.validate("tanner@vapor.codes."))
        XCTAssertThrowsError(try Validator<String>.email.validate("tanner@@vapor.codes"))
        XCTAssertThrowsError(try Validator<String>.email.validate("@vapor.codes"))
        XCTAssertThrowsError(try Validator<String>.email.validate("tanner@codes"))
        XCTAssertThrowsError(try Validator<String>.email.validate("asdf"))
    }
    
    func testRange() throws {
        try Validator<Int>.range(-5...5).validate(4)
        try Validator<Int>.range(-5...5).validate(5)
        try Validator<Int>.range(-5...5).validate(-5)
        XCTAssertThrowsError(try Validator<Int>.range(-5...5).validate(6))
        XCTAssertThrowsError(try Validator<Int>.range(-5...5).validate(-6))

        try Validator<Int>.range(5...).validate(.max)

        try Validator<Int>.range(-5...5).validate(4)
        XCTAssertThrowsError(try Validator<Int>.range(-5...5).validate(6))
        
        try Validator<Int>.range(-5..<6).validate(-5)
        try Validator<Int>.range(-5..<6).validate(-4)
        try Validator<Int>.range(-5..<6).validate(5)
        XCTAssertThrowsError(try Validator<Int>.range(-5..<6).validate(-6))
        XCTAssertThrowsError(try Validator<Int>.range(-5..<6).validate(6))
    }

    func testPhone() throws {
        try Validator<String>.phone(type: .useSimple(.plain)).validate("2399997777")
        try Validator<String>.phone(type: .useSimple(.dashOnly)).validate("239-999-7777")
        try Validator<String>.phone(type: .useSimple(.dashWithParenthesis)).validate("(239)999-7777")
        try Validator<String>.phone(type: .useCountryCode(.plain)).validate("1 2399997777")
        try Validator<String>.phone(type: .useCountryCode(.dashOnly)).validate("72 239-999-7777")
        try Validator<String>.phone(type: .useCountryCode(.dashWithParenthesis)).validate("99 (239)999-7777")

        XCTAssertThrowsError(try Validator<String>.phone(type: .useSimple(.plain)).validate("23999977777"))
        XCTAssertThrowsError(try Validator<String>.phone(type: .useSimple(.dashOnly)).validate("1(239)999-7777"))
        XCTAssertThrowsError(try Validator<String>.phone(type: .useSimple(.dashWithParenthesis)).validate("239-999-7777"))
        XCTAssertThrowsError(try Validator<String>.phone(type: .useCountryCode(.plain)).validate("1239-999-7777"))
        XCTAssertThrowsError(try Validator<String>.phone(type: .useCountryCode(.dashOnly)).validate("72(239)999-7777"))
        XCTAssertThrowsError(try Validator<String>.phone(type: .useCountryCode(.dashWithParenthesis)).validate("99-239-999-777"))
    }
    
    static var allTests = [
        ("testValidate", testValidate),
        ("testASCII", testASCII),
        ("testAlphanumeric", testAlphanumeric),
        ("testEmail", testEmail),
        ("testRange", testRange),
        ("testPhone", testPhone)
    ]
}

final class User: Validatable, Reflectable, Codable {
    var id: Int?
    var name: String
    var age: Int
    var email: String?
    var pet: Pet
    var luckyNumber: Int?
    var phone: String

    init(id: Int? = nil, name: String, age: Int, pet: Pet, phone: String) {
        self.id = id
        self.name = name
        self.age = age
        self.pet = pet
        self.phone = phone
    }


    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)
        // validate name is at least 5 characters and alphanumeric
        try validations.add(\.name, .count(5...) && .alphanumeric)
        // validate age is 18 or older
        try validations.add(\.age, .range(18...))
        // validate the email is valid and is not nil
        try validations.add(\.email, !.nil && .email)
        try validations.add(\.email, .email && !.nil) // test other way
        // validate the email is valid or is nil
        try validations.add(\.email, .nil || .email)
        try validations.add(\.email, .email || .nil) // test other way
        // validate that the lucky number is nil or is 5 or 7
        try validations.add(\.luckyNumber, .nil || .in(5, 7))
        // validate that the phone number format is of the specified format
        try validations.add(\.phone, .phone(type: .useCountryCode(.dashWithParenthesis)))
        print(validations)
        return validations
    }
}

final class Pet: Codable, Validatable, Reflectable {
    var name: String
    var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    static func validations() throws -> Validations<Pet> {
        var validations = Validations(Pet.self)
        try validations.add(\.name, .count(5...) && .characterSet(.alphanumerics + .whitespaces))
        try validations.add(\.age, .range(3...))
        return validations
    }
}
