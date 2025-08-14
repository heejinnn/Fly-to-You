//
//  MockLetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 8/14/25.
//

@testable import Fly_to_You

class MockLetterRepo: LetterRepo{
    
    // Mock 상태 변수들
    var blockLetterCalled = false
    var receivedLetterId: String?
    var callCount = 0
    var shouldThrowError = false
    var errorToThrow: Error?
    
    // blockLetter Mock 구현
    func blockLetter(letterId: String) async throws {
        
        receivedLetterId = letterId
        guard !letterId.isEmpty else { return print("[??]: \(blockLetterCalled)")}
        
        blockLetterCalled = true
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
