import XCTest

class ValidationJSONTests: XCTestCase{

    static let allTests = [
        ("testThatJSONValidatorWorks", testThatJSONValidatorWorks)
    ]

    func testThatJSONValidatorWorks() {
        XCTAssertNoThrow(try JSONValidator().validate(
            "{\n" +
                "\"boolean\": true,\n" +
                "\"object\": {\n" +
                "\"a\": \"b\",\n" +
                "\"c\": \"d\",\n" +
                "\"e\": \"f\"\n" +
                "},\n" +
                "\"array\": [1 , 2],\n" +
                "\"string\": \"Hello World\"\n" +
            "}"
            ))
        XCTAssertThrowsError(try JSONValidator().validate("{notAValidJSON: notValid}"))
    }
    
}
