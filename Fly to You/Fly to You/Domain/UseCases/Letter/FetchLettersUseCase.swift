//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//
import SwiftUI

protocol FetchLettersUseCase{
    func observeReceivedLetters(toUid: String, onUpdate: @escaping ([ReceiveLetter]) -> Void)
    func observeSentLetters(fromUid: String, onUpdate: @escaping ([ReceiveLetter]) -> Void)
    func removeListeners()
}

final class DefaultFetchLettersUseCase: FetchLettersUseCase{
    private let letterRepo: LetterRepo
    private let userRepo: UserRepo
    
    init(
        letterRepo: LetterRepo,
        userRepo: UserRepo
    ) {
        self.letterRepo = letterRepo
        self.userRepo = userRepo
    }

    func observeReceivedLetters(toUid: String, onUpdate: @escaping ([ReceiveLetter]) -> Void) {
        letterRepo.observeReceivedLetters(toUid: toUid) { [weak self] dtos in
            guard let self = self else { return }
            Task {
                let sortedDtos = dtos.sorted { $0.timestamp > $1.timestamp }
                
                // 1. 모든 사용자 ID 추출
                let userIDs = Set(dtos.flatMap { [$0.fromUid, $0.toUid] })
                // 2. 사용자 정보 일괄 조회
                let users = try? await self.userRepo.fetchUsers(uids: Array(userIDs))
                let usersByID = users.map { Dictionary(uniqueKeysWithValues: $0.map { ($0.uid, $0) }) } ?? [:]
                
                // 3. DTO → Model 변환
                let letters: [ReceiveLetter] = sortedDtos.map { dto in
                    let fromUser = usersByID[dto.fromUid]
                    let toUser = usersByID[dto.toUid]
                    return ReceiveLetter(
                        id: dto.id,
                        from: fromUser,
                        to: toUser,
                        message: dto.message,
                        topic: dto.topic,
                        topicId: dto.topicId,
                        timestamp: dto.timestamp,
                        isDelivered: dto.isDelivered,
                        isRelayStart: dto.isRelayStart
                    )
                }
                DispatchQueue.main.async {
                    onUpdate(letters)
                }
            }
        }
    }

    func observeSentLetters(fromUid: String, onUpdate: @escaping ([ReceiveLetter]) -> Void) {
        letterRepo.observeSentLetters(fromUid: fromUid) { [weak self] dtos in
            guard let self = self else { return }
            Task {
                let sortedDtos = dtos.sorted { $0.timestamp > $1.timestamp }
                
                let userIDs = Set(dtos.flatMap { [$0.fromUid, $0.toUid] })
                let users = try? await self.userRepo.fetchUsers(uids: Array(userIDs))
                let usersByID = users.map { Dictionary(uniqueKeysWithValues: $0.map { ($0.uid, $0) }) } ?? [:]
                
                let letters: [ReceiveLetter] = sortedDtos.map { dto in
                    let fromUser = usersByID[dto.fromUid]
                    let toUser = usersByID[dto.toUid]
                    return ReceiveLetter(
                        id: dto.id,
                        from: fromUser,
                        to: toUser,
                        message: dto.message,
                        topic: dto.topic,
                        topicId: dto.topicId,
                        timestamp: dto.timestamp,
                        isDelivered: dto.isDelivered,
                        isRelayStart: dto.isRelayStart
                    )
                }
                DispatchQueue.main.async {
                    onUpdate(letters)
                }
            }
        }
    }

    func removeListeners() {
        letterRepo.removeListeners()
    }
    
}
