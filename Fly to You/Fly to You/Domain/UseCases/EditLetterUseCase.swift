//
//  EditLetterUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/19/25.
//

protocol EditLetterUseCase {
    func editSentLetter(letter: Letter, toNickname: String) async throws -> ReceiveLetter
}

final class DefaultEditLetterUseCase: EditLetterUseCase {
    
    private let userRepo: UserRepo
    private let letterRepo: LetterRepo
    
    init(letterRepo: LetterRepo, userRepo: UserRepo) {
        self.letterRepo = letterRepo
        self.userRepo = userRepo
    }
    
    func editSentLetter(letter: Letter, toNickname: String) async throws -> ReceiveLetter {
        let newLetter = try await letterRepo.editSentLetter(letter: letter)
        let toUid = try await userRepo.fetchUid(nickname: toNickname)
        let userIDs: Set<String> = [letter.fromUid, toUid]
        let users: [User] = try! await userRepo.fetchUsers(uids: Array(userIDs))
        let usersByID = Dictionary(uniqueKeysWithValues: users.map { ($0.uid, $0) })
        
        let fromUser = usersByID[letter.fromUid]
        let toUser = usersByID[letter.toUid]
        
        return ReceiveLetter(
            id: newLetter.id,
            from: fromUser,
            to: toUser,
            message: newLetter.message,
            topic: newLetter.topic,
            topicId: newLetter.topicId,
            timestamp: newLetter.timestamp,
            isDelivered: newLetter.isDelivered,
            isRelayStart: newLetter.isRelayStart)
    }
}
