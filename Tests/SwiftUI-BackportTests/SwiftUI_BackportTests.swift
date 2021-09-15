    import XCTest
    @testable import SwiftUI_Backport
    import SwiftUI

    @available(iOS, introduced: 13)
    final class SwiftUI_BackportTests: XCTestCase {
        func testContentSizeCategoryComparators() {
            let allCases = ContentSizeCategory.allCases
            zip(allCases.dropFirst(), allCases)
                .forEach {
                    XCTAssert($0 > $1)
                    XCTAssert($0 >= $1)
                    XCTAssert($1 < $0)
                    XCTAssert($1 <= $0)
                }
            allCases.enumerated()
                .forEach { offset, lhs in
                    allCases.dropFirst(offset + 1).forEach { rhs in
                        XCTAssert(lhs < rhs)
                        XCTAssert(rhs > lhs)
                    }
                    allCases.dropFirst(offset).forEach { rhs in
                        XCTAssert(lhs <= rhs)
                        XCTAssert(rhs >= lhs)
                    }
                }
            allCases.flatMap { category in
                allCases.map {
                    (category, $0)
                }
            }
            .forEach { lhs, rhs in
                XCTAssert(lhs <= rhs || lhs >= rhs)
                XCTAssert((lhs < rhs || lhs > rhs) || (lhs <= rhs && lhs >= rhs))
            }
        }
    }
