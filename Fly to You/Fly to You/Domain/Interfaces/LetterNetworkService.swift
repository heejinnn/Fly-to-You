//
//  LetterNetworkService.swift
//  Fly to You
//
//  Created by 최희진 on 9/12/25.
//

import Foundation

protocol LetterNetworkService {
    func saveLetter(_ letter: Letter) async throws -> Letter
    func updateIsDelivered(letterId: String, isDelivered: Bool) async throws
    func editLetter(_ letter: Letter) async throws -> ReceiveLetterDto
    func deleteLetter(_ letter: Letter) async throws
    func observeReceivedLetters(toUid: String, onUpdate: @escaping ([ReceiveLetterDto]) -> Void)
    func observeSentLetters(fromUid: String, onUpdate: @escaping ([ReceiveLetterDto]) -> Void)
    func removeListeners()
    func blockLetter(letterId: String) async throws
    func getBlockedLetters() async throws -> [String]
}