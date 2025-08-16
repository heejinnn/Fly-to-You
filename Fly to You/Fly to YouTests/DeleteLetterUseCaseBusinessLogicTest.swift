//
//  DeleteLetterUseCaseBusinessLogicTest.swift
//  Fly to YouTests
//
//  Created by Claude on 8/16/25.
//

import XCTest
@testable import Fly_to_You

final class DeleteLetterUseCaseBusinessLogicTest: XCTestCase {
    
    var sut: DefaultDeleteLetterUseCase!
    
    override func setUpWithError() throws {
        // Mock repos는 실제로 사용 X, 인스턴스 생성을 위해 임시 Mock 사용
        sut = DefaultDeleteLetterUseCase(letterRepo: MockLetterRepo(), flightRepo: DummyFlightRepo())
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - findPreviousLetterId Tests
    
    //normal 이전 Id 조회 테스트
    func test_findPreviousLetterId_withValidPreviousLetter_returnsPreviousId() {
        // Given
        let routes: [[String: Any]] = [
            ["id": "letter1", "fromUid": "user1"],
            ["id": "letter2", "fromUid": "user2"],
            ["id": "letter3", "fromUid": "user3"]
        ]
        
        // When
        let result = sut.findPreviousLetterId(in: routes, currentLetterId: "letter3")
        
        // Then
        XCTAssertEqual(result, "letter2")
    }
    
    //첫 번째 편지의 이전 편지를 찾으려 할 때 테스트
    func test_findPreviousLetterId_withFirstLetter_returnsNil() {
        // Given
        let routes: [[String: Any]] = [
            ["id": "letter1", "fromUid": "user1"],
            ["id": "letter2", "fromUid": "user2"],
            ["id": "letter3", "fromUid": "user3"]
        ]
        
        // When
        let result = sut.findPreviousLetterId(in: routes, currentLetterId: "letter1")
        
        // Then
        XCTAssertNil(result)
    }
    
    //없는 Id 값을 넣은 경우
    func test_findPreviousLetterId_withNonExistingLetter_returnsNil() {
        // Given
        let routes: [[String: Any]] = [
            ["id": "letter1", "fromUid": "user1"],
            ["id": "letter2", "fromUid": "user2"],
            ["id": "letter3", "fromUid": "user3"]
        ]
        
        // When
        let result = sut.findPreviousLetterId(in: routes, currentLetterId: "letter999")
        
        // Then
        XCTAssertNil(result)
    }
    
    //빈 배열에서 이전 Id 값을 찾으려는 경우
    func test_findPreviousLetterId_withEmptyRoutes_returnsNil() {
        // Given
        let routes: [[String: Any]] = []
        
        // When
        let result = sut.findPreviousLetterId(in: routes, currentLetterId: "letter1")
        
        // Then
        XCTAssertNil(result)
    }
    
    // MARK: - Complex Integration Tests for Business Logic
    
    // 복잡한 릴레이 시나리오: start-letter -> middle-letter-1 -> middle-letter-2 -> middle-letter-3 -> end-letter
    func test_findPreviousLetterId_withComplexRouteStructure_handlesCorrectly() {
        // Given
        let routes: [[String: Any]] = [
            ["id": "start-letter", "fromUid": "user1", "topic": "Start", "isRelayStart": true],
            ["id": "middle-letter-1", "fromUid": "user2", "topic": "Continue"],
            ["id": "middle-letter-2", "fromUid": "user3", "topic": "Continue"],
            ["id": "middle-letter-3", "fromUid": "user4", "topic": "Continue"],
            ["id": "end-letter", "fromUid": "user5", "topic": "End"]
        ]
        
        // When & Then - 각 편지의 이전 편지를 올바르게 찾는지 테스트
        XCTAssertNil(sut.findPreviousLetterId(in: routes, currentLetterId: "start-letter"))
        XCTAssertEqual(sut.findPreviousLetterId(in: routes, currentLetterId: "middle-letter-1"), "start-letter")
        XCTAssertEqual(sut.findPreviousLetterId(in: routes, currentLetterId: "middle-letter-2"), "middle-letter-1")
        XCTAssertEqual(sut.findPreviousLetterId(in: routes, currentLetterId: "middle-letter-3"), "middle-letter-2")
        XCTAssertEqual(sut.findPreviousLetterId(in: routes, currentLetterId: "end-letter"), "middle-letter-3")
    }
    
    // MARK: - Performance Tests
    
    func test_findPreviousLetterId_performance() {
        // Given - 대량의 routes 데이터
        let largeRoutes: [[String: Any]] = (1...10000).map { index in
            ["id": "letter\(index)", "fromUid": "user\(index)"]
        }
        
        // When & Then
        self.measure {
            let result = sut.findPreviousLetterId(in: largeRoutes, currentLetterId: "letter5000")
            XCTAssertEqual(result, "letter4999")
        }
    }
}
