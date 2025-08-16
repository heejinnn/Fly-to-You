//
//  GetParticipationCountUseCaseTest.swift
//  Fly to YouTests
//
//  Created by 최희진 on 8/16/25.
//

import XCTest
@testable import Fly_to_You

final class GetParticipationCountUseCaseTest: XCTestCase {
    
    var sut: DefaultGetParticipationCountUseCase!
    
    override func setUpWithError() throws {
        sut = DefaultGetParticipationCountUseCase()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Test Cases
    
    // normal 참여 count 조회
    func test_execute_withUniqueParticipants_returnsCorrectCount() {
        // Given
        let user1 = User(uid: "user1", nickname: "User1", createdAt: Date(), fcmToken: "", reportedCount: 0, blockedLetters: [])
        let user2 = User(uid: "user2", nickname: "User2", createdAt: Date(), fcmToken: "", reportedCount: 0, blockedLetters: [])
        let user3 = User(uid: "user3", nickname: "User3", createdAt: Date(), fcmToken: "", reportedCount: 0, blockedLetters: [])
        
        let route1 = ReceiveLetterModel(
            id: "letter1",
            from: user1,
            to: user2,
            message: "Hello",
            topic: "Greeting",
            topicId: "topic1",
            timestamp: Date(),
            isDelivered: true,
            isRelayStart: true,
            isBlocked: false
        )
        
        let route2 = ReceiveLetterModel(
            id: "letter2",
            from: user2,
            to: user3,
            message: "Hello again",
            topic: "Greeting",
            topicId: "topic1",
            timestamp: Date(),
            isDelivered: true,
            isRelayStart: false,
            isBlocked: false
        )
        
        let route3 = ReceiveLetterModel(
            id: "letter3",
            from: user3,
            to: user1,
            message: "Reply",
            topic: "Greeting",
            topicId: "topic1",
            timestamp: Date(),
            isDelivered: true,
            isRelayStart: false,
            isBlocked: false
        )
        
        let flight = FlightModel(
            id: "flight1",
            topic: "Test Topic",
            startDate: Date(),
            routes: [route1, route2, route3]
        )
        
        // When
        let result = sut.execute(for: flight)
        
        // Then
        XCTAssertEqual(result, 3)
    }
    
    //참여자가 없는 경우
    func test_execute_withEmptyRoutes_returnsZero() {
        // Given
        let flight = FlightModel(
            id: "flight1",
            topic: "Empty Flight",
            startDate: Date(),
            routes: []
        )
        
        // When
        let result = sut.execute(for: flight)
        
        // Then
        XCTAssertEqual(result, 0)
    }
    
    // 복잡한 릴레이 시나리오: user1 -> user2 -> user3 -> user1 -> user4
    func test_execute_withComplexScenario_returnsCorrectCount() {
        // Given
        let user1 = User(uid: "user1", nickname: "User1", createdAt: Date(), fcmToken: "", reportedCount: 0, blockedLetters: [])
        let user2 = User(uid: "user2", nickname: "User2", createdAt: Date(), fcmToken: "", reportedCount: 0, blockedLetters: [])
        let user3 = User(uid: "user3", nickname: "User3", createdAt: Date(), fcmToken: "", reportedCount: 0, blockedLetters: [])
        let user4 = User(uid: "user4", nickname: "User4", createdAt: Date(), fcmToken: "", reportedCount: 0, blockedLetters: [])
        
        let routes = [
            ReceiveLetterModel(id: "1", from: user1, to: user2, message: "1", topic: "Topic", topicId: "topic1", timestamp: Date(), isDelivered: true, isRelayStart: true, isBlocked: false),
            ReceiveLetterModel(id: "2", from: user2, to: user3, message: "2", topic: "Topic", topicId: "topic1", timestamp: Date(), isDelivered: true, isRelayStart: false, isBlocked: false),
            ReceiveLetterModel(id: "3", from: user3, to: user1, message: "3", topic: "Topic", topicId: "topic1", timestamp: Date(), isDelivered: true, isRelayStart: false, isBlocked: false),
            ReceiveLetterModel(id: "4", from: user1, to: user4, message: "4", topic: "Topic", topicId: "topic1", timestamp: Date(), isDelivered: true, isRelayStart: false, isBlocked: false),
            ReceiveLetterModel(id: "5", from: user4, to: user2, message: "5", topic: "Topic", topicId: "topic1", timestamp: Date(), isDelivered: true, isRelayStart: false, isBlocked: false)
        ]
        
        let flight = FlightModel(
            id: "flight1",
            topic: "Complex Flight",
            startDate: Date(),
            routes: routes
        )
        
        // When
        let result = sut.execute(for: flight)
        
        // Then
        XCTAssertEqual(result, 4) // user1, user2, user3, user4 모두 참여
    }
    
    // MARK: - Performance Tests
    
    func test_execute_performance() throws {
        // Given
        let users = (1...1000).map { index in
            User(uid: "user\(index)", nickname: "User\(index)", createdAt: Date(), fcmToken: "", reportedCount: 0, blockedLetters: [])
        }
        
        let routes = users.enumerated().map { index, user in
            let toUser = users[(index + 1) % users.count] // 다음 유저에게 전송
            return ReceiveLetterModel(
                id: "letter\(index)",
                from: user,
                to: toUser,
                message: "Message \(index)",
                topic: "Performance Test",
                topicId: "topic1",
                timestamp: Date(),
                isDelivered: true,
                isRelayStart: index == 0,
                isBlocked: false
            )
        }
        
        let flight = FlightModel(
            id: "performanceTest",
            topic: "Performance Test",
            startDate: Date(),
            routes: routes
        )
        
        // When & Then
        self.measure {
            let result = sut.execute(for: flight)
            XCTAssertEqual(result, 1000)
        }
    }
}
