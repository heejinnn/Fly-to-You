//
//  LetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

protocol LetterRepo{
    func save(letter: Letter) async throws -> Letter
    func updateIsDelivered(letterId: String, isDelivered: Bool) async throws
    func fetchReceivedLetters(toUid: String) async throws -> [ReceiveLetterDto]
    func fetchSentLetters(fromUid: String) async throws -> [ReceiveLetterDto]
    func editSentLetter(letter: Letter) async throws -> ReceiveLetterDto
    func deleteSentLetter(letter: Letter) async throws
}
