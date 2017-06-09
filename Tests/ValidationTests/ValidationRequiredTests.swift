import XCTest

class ValidationRequiredTests: XCTestCase {
    static let allTests = [
        ("testThatRequiredValidatorWorks", testThatRequiredValidatorWorks)
    ]

    func testThatRequiredValidatorWorks() {
        XCTAssertThrowsError(try Required().validate(""))
        XCTAssertThrowsError(try Required().validate([]))
        XCTAssertThrowsError(try Required().validate(nil))
        XCTAssertNoThrow(try Required().validate("notEmpty"))
        XCTAssertNoThrow(try Required().validate(["notEmpty"]))
        XCTAssertNoThrow(try Required().validate(1))
    }
}
