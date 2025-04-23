//
//  EditLetterUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/19/25.
//

protocol EditLetterUseCase {
    func editSentLetter(letter: Letter, toUid: String) async throws -> ReceiveLetter
}

final class DefaultEditLetterUseCase: EditLetterUseCase {
    
    private let userRepo: UserRepo
    private let letterRepo: LetterRepo
    private let flightRepo: FlightRepo
    
    init(letterRepo: LetterRepo, userRepo: UserRepo, flightRepo: FlightRepo) {
        self.letterRepo = letterRepo
        self.userRepo = userRepo
        self.flightRepo = flightRepo
    }
    
    func editSentLetter(letter: Letter, toUid: String) async throws -> ReceiveLetter {
        let newLetter = try await letterRepo.editSentLetter(letter: letter)
        try await flightRepo.updateRoute(letter: letter)
      
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
