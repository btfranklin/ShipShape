import XCTest
@testable import ShipShape

final class ShipShapeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ShipShape().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
