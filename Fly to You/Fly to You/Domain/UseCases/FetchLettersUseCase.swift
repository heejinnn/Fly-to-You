//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

protocol FetchLettersUseCase{
    func execute(toUid: String) async throws -> [ReceiveLetter]
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
    
    func execute(toUid: String) async throws -> [ReceiveLetter] {
        // 1. 편지 목록을 가져옴 (fromUid, toUid 정보만 있는 임시 모델)
        let letterDTOs = try await letterRepo.fetchLetters(toUid: toUid)
        guard !letterDTOs.isEmpty else { return [] }
        
        // 2. 관련된 모든 UID 추출
        let userIDs = Set(letterDTOs.flatMap { [$0.fromUid, $0.toUid] })
        
        // 3. 유저 정보 일괄 조회
        let users = try await userRepo.fetchUsers(uids: Array(userIDs))
        let usersByID = Dictionary(uniqueKeysWithValues: users.map { ($0.uid, $0) })
        
        // 4. ReceiveLetter로 변환
        let letters: [ReceiveLetter] = letterDTOs.map { dto in
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
                isDelivered: dto.isDelivered
            )
        }
        
        return letters
    }
}
