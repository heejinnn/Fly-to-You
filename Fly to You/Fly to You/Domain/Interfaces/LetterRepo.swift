//
//  LetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

protocol LetterRepo{
    func save(letter: Letter) async throws -> Letter
    func updateIsDelivered(letter: Letter) async throws
    func fetchLetters(toUid: String) async throws -> [ReceiveLetterDto]
}
