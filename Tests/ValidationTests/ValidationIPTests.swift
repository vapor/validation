import XCTest

class ValidationIPTests: XCTestCase {
    static let allTests = [
        ("testThatIPv4AddressValidatorWorks", testThatIPv4AddressValidatorWorks),
        ("testThatIPv6AddressValidatorWorks", testThatIPv6AddressValidatorWorks),
        ("testThatGenericIPAddressValidatorWorks", testThatGenericIPAddressValidatorWorks)
    ]

    func testThatIPv4AddressValidatorWorks() {
        XCTAssertNoThrow(try IPAddress.ipv4.validate("0.0.0.0"))
        XCTAssertNoThrow(try IPAddress.ipv4.validate("255.255.255.255"))
        XCTAssertThrowsError(try IPAddress.ipv4.validate("300.300.300.300"))   //  Values out of range
        XCTAssertThrowsError(try IPAddress.ipv4.validate("255.255.255"))       //  Missing values
    }

    func testThatIPv6AddressValidatorWorks() {
        XCTAssertNoThrow(try IPAddress.ipv6.validate("::"))
        XCTAssertNoThrow(try IPAddress.ipv6.validate("2001::25de::cade"))
        XCTAssertNoThrow(try IPAddress.ipv6.validate("2001:0DB8::1428:57ab"))
        XCTAssertNoThrow(try IPAddress.ipv6.validate("2001:0DB8:0000:0000:0000:0000:1428:57ab"))
        XCTAssertThrowsError(try IPAddress.ipv6.validate("255.255.255.255"))
        XCTAssertThrowsError(try IPAddress.ipv6.validate("xxxx:"))
    }

    func testThatGenericIPAddressValidatorWorks() {
        XCTAssertNoThrow(try IPAddress.ip.validate("0.0.0.0"))
        XCTAssertNoThrow(try IPAddress.ip.validate("255.255.255.255"))
        XCTAssertNoThrow(try IPAddress.ip.validate("2001:0DB8::1428:57ab"))
        XCTAssertNoThrow(try IPAddress.ip.validate("::"))
    }

}
