import Core
import Validation
import XCTest

class ValidationTests: XCTestCase {
    func testValidate() throws {
        let user = User(name: "Tanner", age: 23, pet: Pet(name: "Zizek Pulaski", age: 4))
        user.email = "tanner@vapor.codes"
        try user.validate()
        try user.pet.validate()
    }

    func testASCII() throws {
        try Validation.ascii.validate(.string("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"))
        try Validation.ascii.validate(.string("\n\r\t"))
        XCTAssertThrowsError(try Validation.ascii.validate(.string("\n\r\t\u{129}")))
        try Validation.ascii.validate(.string(" !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"))
        XCTAssertThrowsError(try Validation.ascii.validate(.string("ABCDEFGHIJKLMNOPQR🤠STUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"))) {
            XCTAssert($0 is ValidationError)
        }
    }

    func testAlphanumeric() throws {
        try Validation.alphanumeric.validate(.string("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"))
        XCTAssertThrowsError(try Validation.alphanumeric.validate(.string("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"))) {
            XCTAssert($0 is ValidationError)
        }
    }

    func testEmail() throws {
        try Validation.email.validate(.string("tanner@vapor.codes"))
        XCTAssertThrowsError(try Validation.email.validate(.string("tanner@vapor.codestanner@vapor.codes")))
        XCTAssertThrowsError(try Validation.email.validate(.string("tanner@vapor.codes.")))
        XCTAssertThrowsError(try Validation.email.validate(.string("tanner@@vapor.codes")))
        XCTAssertThrowsError(try Validation.email.validate(.string("@vapor.codes")))
        XCTAssertThrowsError(try Validation.email.validate(.string("tanner@codes")))
        XCTAssertThrowsError(try Validation.email.validate(.string("asdf"))) { XCTAssert($0 is ValidationError) }
    }
    
    func testRange() throws {
        try Validation.range(-5...5).validate(.int(4))
        try Validation.range(-5...5).validate(.int(5))
        try Validation.range(-5...5).validate(.int(-5))
        XCTAssertThrowsError(try Validation.range(-5...5).validate(.int(6))) { XCTAssert($0 is ValidationError) }
        XCTAssertThrowsError(try Validation.range(-5...5).validate(.int(-6))) { XCTAssert($0 is ValidationError) }

        try Validation.range(5...).validate(.int(.max))
        XCTAssertThrowsError(try Validation.range(...Int.max).validate(UInt.max.convertToValidationData()))

        try Validation.range(-5...5).validate(.int(4))
        XCTAssertThrowsError(try Validation.range(-5...5).validate(.int(6))) { XCTAssert($0 is ValidationError) }
        
        try Validation.range(-5..<6).validate(.int(-5))
        try Validation.range(-5..<6).validate(.int(-4))
        try Validation.range(-5..<6).validate(.int(5))
        XCTAssertThrowsError(try Validation.range(-5..<6).validate(.int(-6))) { XCTAssert($0 is ValidationError) }
        XCTAssertThrowsError(try Validation.range(-5..<6).validate(.int(6))) { XCTAssert($0 is ValidationError) }
    }
    
    static var allTests = [
        ("testValidate", testValidate),
        ("testASCII", testASCII),
        ("testAlphanumeric", testAlphanumeric),
        ("testEmail", testEmail),
        ("testRange", testRange),
    ]
}

final class User: Validatable, Reflectable, Codable {
    var id: Int?
    var name: String
    var age: Int
    var email: String?
    var pet: Pet

    init(id: Int? = nil, name: String, age: Int, pet: Pet) {
        self.id = id
        self.name = name
        self.age = age
        self.pet = pet
    }


    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)
        // validate name is at least 5 characters and alphanumeric
        try validations.add(\.name, .range(5...) && .alphanumeric)
        // validate age is 18 or older
        try validations.add(\.age, .range(18...))
        // validate the email exists and is not nil
        try validations.add(\.email, .email && !.nil)
        return validations
    }

    static func validations2() throws -> Validations<User> {
        return try [
            validationKey(\.name): .range(5...) && .alphanumeric,
            validationKey(\.age): .range(3...),
            validationKey(\.pet.name): .range(5...)
        ]
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
        try validations.add(\.name, .range(5...) && .characterSet(.alphanumerics + .whitespaces))
        try validations.add(\.age, .range(3...))
        return validations
    }
}
