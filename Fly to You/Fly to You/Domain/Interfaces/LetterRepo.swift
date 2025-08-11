//
//  LetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

protocol LetterRepo{
    func save(letter: Letter) async throws -> Letter
    func updateIsDelivered(letterId: String, isDelivered: Bool) async throws
    func editSentLetter(letter: Letter) async throws -> ReceiveLetterDto
    func deleteSentLetter(letter: Letter) async throws
    func observeReceivedLetters(toUid: String, onUpdate: @escaping ([ReceiveLetterDto]) -> Void)
    func observeSentLetters(fromUid: String, onUpdate: @escaping ([ReceiveLetterDto]) -> Void)
    func removeListeners()
    func blockLetter(letterId: String) async throws
    func getBlockedLetters() async throws -> [String] 
}
