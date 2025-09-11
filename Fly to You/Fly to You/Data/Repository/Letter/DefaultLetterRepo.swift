//
//  DefaultLetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import Foundation

final class DefaultLetterRepo: LetterRepo {
    private let letterNetworkService: LetterNetworkService
    
    init(letterNetworkService: LetterNetworkService) {
        self.letterNetworkService = letterNetworkService
    }
    
    func save(letter: Letter) async throws -> Letter {
        return try await letterNetworkService.saveLetter(letter)
    }
    
    func updateIsDelivered(letterId: String, isDelivered: Bool) async throws {
        try await letterNetworkService.updateIsDelivered(letterId: letterId, isDelivered: isDelivered)
    }
    
    func editSentLetter(letter: Letter) async throws -> ReceiveLetterDto {
        return try await letterNetworkService.editLetter(letter)
    }
    
    func deleteSentLetter(letter: Letter) async throws {
        try await letterNetworkService.deleteLetter(letter)
    }
    
    func observeReceivedLetters(toUid: String, onUpdate: @escaping ([ReceiveLetterDto]) -> Void) {
        letterNetworkService.observeReceivedLetters(toUid: toUid, onUpdate: onUpdate)
    }
    
    func observeSentLetters(fromUid: String, onUpdate: @escaping ([ReceiveLetterDto]) -> Void) {
        letterNetworkService.observeSentLetters(fromUid: fromUid, onUpdate: onUpdate)
    }
    
    func removeListeners() {
        letterNetworkService.removeListeners()
    }
    
    func blockLetter(letterId: String) async throws {
        try await letterNetworkService.blockLetter(letterId: letterId)
    }
     
    func getBlockedLetters() async throws -> [String] {
        return try await letterNetworkService.getBlockedLetters()
    }
}
