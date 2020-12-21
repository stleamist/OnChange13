import XCTest
@testable import OnChange13

import SwiftUI

final class OnChange13Tests: XCTestCase {
    
    func test1() {
        let value1: String? = nil
        let value2: Int = 0
        XCTAssertEqual(AnyEquatable(value1) == AnyEquatable(value2), false)
        XCTAssertEqual(AnyEquatable(value2) == AnyEquatable(value1), false)
    }

    func test2() {
        let value1: Int? = nil
        let value2: Int?? = nil
        XCTAssertEqual(AnyEquatable(value1) == AnyEquatable(value2), true)
        XCTAssertEqual(AnyEquatable(value2) == AnyEquatable(value1), true)
    }
}
