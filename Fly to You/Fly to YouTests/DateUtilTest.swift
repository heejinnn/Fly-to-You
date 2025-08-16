//
//  DateUtilTest.swift
//  Fly to YouTests
//
//  Created by 최희진 on 8/16/25.
//

import XCTest
@testable import Fly_to_You

final class DateUtilTest: XCTestCase {
    
    func test_formatLetterDate_withSpecificDate_returnsCorrectFormat() {
        // Given
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let components = DateComponents(year: 2025, month: 8, day: 16)
        let date = calendar.date(from: components)!
        
        // When
        let formattedDate = DateUtil.convertToDateString(date)
            
        // Then
        XCTAssertEqual(formattedDate, "2025.08.16")
    }
    
    func test_letterDateFormatter_hasCorrectDateFormat() {
        // When
        let formatter = DateUtil.letterDateFormatter
        
        // Then
        XCTAssertEqual(formatter.dateFormat, "yyyy.MM.dd")
    }
}
