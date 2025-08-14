//
//  Fly_to_YouTests.swift
//  Fly to YouTests
//
//  Created by 최희진 on 4/12/25.
//

import XCTest
@testable import Fly_to_You

final class Fly_to_YouTests: XCTestCase {
    
    var sut: DefaultBlockLetterUseCase!
    var mockLetterRepo: MockLetterRepo!

    override func setUpWithError() throws {
        mockLetterRepo = MockLetterRepo()
        sut = DefaultBlockLetterUseCase(letterRepo: mockLetterRepo)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockLetterRepo = nil
    }

    //정상적인 호출
    func test_blockLetter_success() async throws {
        //Given
        let letterId = "letter123"
    
        //When
    
        try await sut.blockLetter(letterId: letterId)
        
        //Then
        
        XCTAssertTrue(mockLetterRepo.blockLetterCalled)
        XCTAssertEqual(mockLetterRepo.receivedLetterId, letterId)
        
    }
    
    //빈 ID값인 경우 
    func test_blockLetter_emptyId() async throws{
        //Given
        let letterId = ""
        
        //When
        
        try await sut.blockLetter(letterId: letterId)
        
        //Then
        
        XCTAssertTrue(mockLetterRepo.blockLetterCalled)
        XCTAssertEqual(mockLetterRepo.receivedLetterId, "")
    }

    func testPerformanceExample() throws {
        
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class MockLetterRepo: LetterRepo{
    
    // Mock 상태 변수들
    var blockLetterCalled = false
    var receivedLetterId: String?
    var callCount = 0
    var shouldThrowError = false
    var errorToThrow: Error?
    
    // blockLetter Mock 구현
    func blockLetter(letterId: String) async throws {
        guard letterId.isEmpty else { return }
        
        blockLetterCalled = true
        receivedLetterId = letterId
        callCount += 1
        
        if shouldThrowError, let error = errorToThrow {
            throw error
        }
    }
    
    func save(letter: Fly_to_You.Letter) async throws -> Fly_to_You.Letter {
        return letter
    }
    
    func updateIsDelivered(letterId: String, isDelivered: Bool) async throws {
        
    }
    
    func editSentLetter(letter: Letter) async throws -> ReceiveLetterDto {
        return ReceiveLetterDto(
            id: letter.id,
            fromUid: letter.fromUid,
            toUid: letter.toUid,
            message: letter.message,
            topic: letter.topic,
            topicId: letter.topicId,
            timestamp: letter.timestamp,
            isDelivered: false,
            isRelayStart: letter.isRelayStart
        )
    }
    
    func deleteSentLetter(letter: Fly_to_You.Letter) async throws {
        
    }
    
    func observeReceivedLetters(toUid: String, onUpdate: @escaping ([Fly_to_You.ReceiveLetterDto]) -> Void) {
        
    }
    
    func observeSentLetters(fromUid: String, onUpdate: @escaping ([Fly_to_You.ReceiveLetterDto]) -> Void) {
        
    }
    
    func removeListeners() {
        
    }
    
    func getBlockedLetters() async throws -> [String] {
        return []
    }
    
}
