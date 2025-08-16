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
    
    func test_letterDateFormatter_hasCorrectLocale() {
        // When
        let formatter = DateUtil.letterDateFormatter
        
        // Then
        XCTAssertEqual(formatter.locale.identifier, "ko_KR")
    }
    
    func test_letterDateFormatter_hasCorrectDateFormat() {
        // When
        let formatter = DateUtil.letterDateFormatter
        
        // Then
        XCTAssertEqual(formatter.dateFormat, "yyyy.MM.dd")
    }
    
    func test_formatLetterDate_multipleCallsWithSameDate_returnsSameResult() {
        // Given
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let components = DateComponents(year: 2025, month: 6, day: 15)
        let date = calendar.date(from: components)!
        
        // When
        let formattedDate1 = DateUtil.convertToDateString(date)
        let formattedDate2 = DateUtil.convertToDateString(date)
        
        // Then
        XCTAssertEqual(formattedDate1, formattedDate2)
        XCTAssertEqual(formattedDate1, "2025.06.15")
    }
}
