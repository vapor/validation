//
//  EventTests.swift
//  Vapor
//
//  Created by Logan Wright on 4/6/16.
//
//

import XCTest

class Name: Validator {
    func validate(_ input: String) throws {
        let evaluation = OnlyAlphanumeric()
            && Count.min(5)
            && Count.max(20)

        try evaluation.validate(input)
    }
}

class ValidationTests: XCTestCase {
    static let allTests = [
        ("testName", testName),
        ("testPassword", testPassword),
        ("testNot", testNot),
        ("testComposition", testComposition),
        ("testDetailedFailure", testDetailedFailure),
        ("testValidEmail", testValidEmail),
        ("testValidHexadecimal", testValidHexadecimal),
        ("testValidMacAddress", testValidMacAddress),
        ("testValidUUID", testValidUUID),
        ("testValidMongoID", testValidMongoID),
        ("testValidMD5", testValidMD5),
        ("testValidBase64", testValidBase64),
        ("testValidASCII", testValidASCII)
    ]

    func testName() throws {
        try "fancyUser".validated(by: Name())
        try Name().validate("fancyUser")
    }

    func testPassword() throws {
        do {
            try "no".validated(by: !OnlyAlphanumeric() && Count.min(5))
            XCTFail("Should error")
        } catch {}

        try "yes*/pass".validated(by: !OnlyAlphanumeric() && Count.min(5))
    }

    func testNot() {
        XCTAssertFalse("a".passes(!OnlyAlphanumeric()))
    }

    func testComposition() throws {
        let contrived = Count.max(9)
            || Count.min(11)
            && Name()
            && OnlyAlphanumeric()

        try "contrive".validated(by: contrived)
    }

    func testDetailedFailure() throws {
        let fail = Count<Int>.min(10)
        let pass = Count<Int>.max(30)
        let combo = pass && fail
        do {
            let _ = try 2.tested(by: combo)
            XCTFail("should throw error")
        } catch let e as ErrorList {
            XCTAssertEqual(e.errors.count, 1)
        }
    }

    func testValidEmail() {
        XCTAssertFalse("".passes(EmailValidator()))
        XCTAssertFalse("@".passes(EmailValidator()))
        XCTAssertFalse("@.".passes(EmailValidator()))
        XCTAssertFalse("@.com".passes(EmailValidator()))
        XCTAssertFalse("foo@.com".passes(EmailValidator()))
        XCTAssertFalse("@foo.com".passes(EmailValidator()))
        XCTAssertTrue("f@b.co".passes(EmailValidator()))
        XCTAssertTrue("foo@bar.com".passes(EmailValidator()))
        XCTAssertTrue("SOMETHING@SOMETHING.SOMETHING".passes(EmailValidator()))
        XCTAssertTrue("foo-bar-baz@foo.bar".passes(EmailValidator()))
        XCTAssertFalse("f@b.".passes(EmailValidator()))
        XCTAssertFalse("æøå@gmail.com".passes(EmailValidator()))
        XCTAssertFalse(">a@b.co".passes(EmailValidator()))
        XCTAssertFalse("a@b.co<".passes(EmailValidator()))
    }

    func testValidHexadecimal() {
        XCTAssertTrue("abcdefABCDEF0123456789".passes(HexadecimalValidator()))
        XCTAssertTrue("f3f3f3".passes(HexadecimalValidator()))
        XCTAssertFalse("fefefo".passes(HexadecimalValidator()))
        XCTAssertFalse("Not a valid hex".passes(HexadecimalValidator()))
    }

    func testValidMacAddress() {
        XCTAssertTrue("e6:5e:6c:10:77:d3".passes(MacAddressValidator()))
        XCTAssertTrue("c6-59-50-94-3f-e0".passes(MacAddressValidator()))
        XCTAssertTrue("7ab3.5f8d.f56e".passes(MacAddressValidator()))
    }

    func testValidUUID() {
        XCTAssertNoThrow(try UUIDValidator.uuid1.validate("6be2ff40-6a7d-11e7-907b-a6006ad3dba0"))
        XCTAssertThrowsError(try UUIDValidator.uuid1.validate("8cfa13d0-6a7d-51e7-907b-a6006ad3dbb7"))
        XCTAssertNoThrow(try UUIDValidator.uuid2.validate("ccc1bf4a-617d-21d7-8459-0023dffdb426"))
        XCTAssertThrowsError(try UUIDValidator.uuid2.validate("e7938f74-6a7d-61b7-8e23-0063dffad455"))
        XCTAssertNoThrow(try UUIDValidator.uuid3.validate("e106e283-4459-347c-b151-040c9b38c52a"))
        XCTAssertThrowsError(try UUIDValidator.uuid3.validate("f17fb9d3-8c5e-1bd2-a0b7-45dd87dd4f7b"))
        XCTAssertNoThrow(try UUIDValidator.uuid4.validate("e18fb0d3-8c5e-4bc2-aad7-45dd87cc447b"))
        XCTAssertThrowsError(try UUIDValidator.uuid4.validate("6ad2f2d0-6a7e-11e7-97b2-0023dffdd425"))
        XCTAssertNoThrow(try UUIDValidator.uuid5.validate("bac02c65-7aa9-5c49-abef-edfe6ad7100c"))
        XCTAssertThrowsError(try UUIDValidator.uuid5.validate("f68fb0d3-8c5e-4bc2-aad7-45dd87cc447b"))
        XCTAssertNoThrow(try UUIDValidator.uuid.validate("e18fb0d3-8c5e-4bc2-aad7-45dd87cc447b"))
        XCTAssertThrowsError(try UUIDValidator.uuid.validate("will throw"))
    }

    func testValidMongoID() {
        XCTAssertTrue("596b028b40ee490e12038866".passes(MongoIDValidator()))
        XCTAssertTrue("507f1f77bcf86cd799439011".passes(MongoIDValidator()))
        XCTAssertFalse("507z1f77zzf86ch799j39011".passes(MongoIDValidator()))
        XCTAssertFalse("Not A Valid MongoId".passes(MongoIDValidator()))
    }

    func testValidMD5() {
        XCTAssertTrue("d41d8cd98f00b204e9800998ecf8427e".passes(MD5Validator()))
        XCTAssertTrue("e7211b1d5948d21eef524327740094b4".passes(MD5Validator()))
        XCTAssertFalse("d6db347e8ee25f8dcffddad9d1207e1bf".passes(MD5Validator()))
        XCTAssertFalse("19554ad801e6dd97903O9ed752b4a6ce".passes(MD5Validator()))
    }

    func testValidBase64() {
        XCTAssertTrue("SSBsb3ZlIFZhcG9y".passes(Base64Validator()))
        XCTAssertTrue("VmFwb3IgPiBFeHByZXNz".passes(Base64Validator()))
        XCTAssertFalse("bWFsZmalformedl9ybWVk".passes(Base64Validator()))
        XCTAssertFalse("".passes(Base64Validator()))
    }

    func testValidASCII() {
        XCTAssertTrue(" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~".passes(ASCIIValidator()))
        XCTAssertFalse("piędziesięciogroszówka".passes(ASCIIValidator()))
    }

}
