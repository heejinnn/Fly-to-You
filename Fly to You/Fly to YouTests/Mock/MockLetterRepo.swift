//
//  MockLetterRepo 2.swift
//  Fly to You
//
//  Created by 최희진 on 8/16/25.
//

@testable import Fly_to_You
import Foundation

class MockLetterRepo: LetterRepo {
    func updateIsDelivered(letterId: String, isDelivered: Bool) async throws {}
    func deleteSentLetter(letter: Fly_to_You.Letter) async throws {}
    func blockLetter(letterId: String) async throws {}
    func save(letter: Fly_to_You.Letter) async throws -> Fly_to_You.Letter {
        return Letter(id: "", fromUid: "", toUid: "", message: "", topic: "", topicId: "", timestamp: Date(), isDelivered: false, isRelayStart: false)
    }
    func editSentLetter(letter: Fly_to_You.Letter) async throws -> Fly_to_You.ReceiveLetterDto {
        return ReceiveLetterDto(id: "", fromUid: "", toUid: "", message: "", topic: "", topicId: "", timestamp: Date(), isDelivered: false, isRelayStart: false)
    }
    func observeReceivedLetters(toUid: String, onUpdate: @escaping ([Fly_to_You.ReceiveLetterDto]) -> Void) {}
    func observeSentLetters(fromUid: String, onUpdate: @escaping ([Fly_to_You.ReceiveLetterDto]) -> Void) {}
    func removeListeners() {}
    func getBlockedLetters() async throws -> [String] {
        return []
    }
    
}
