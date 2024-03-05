//
//  DateCalculatorTests.swift
//  GundyMarketTests
//
//  Created by Gundy on 3/4/24.
//

import XCTest
@testable import GundyMarket

final class DateCalculatorTests: XCTestCase {
    private var sut: DateCalculator!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        sut = DateCalculator(dateFormatter: formatter)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }

    func testDateCalculator_1일_늦은_날짜를_넣으면_86400을_반환한다() {
        // given
        let date = Date(timeIntervalSinceReferenceDate: 0)
        let string = "2001-01-02T00:00:00"
        
        // when
        let result = sut.timeInterval(from: string, since: date)
        let expectedValue = 86400.0
        
        // then
        XCTAssertEqual(result, expectedValue)
    }
}
