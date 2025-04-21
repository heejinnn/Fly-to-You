//
//  RelayLetterUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import Foundation

protocol RelayLetterUseCase{
    func send(toNickname: String, topic: String, topicId: String, message: String, previousLetter: Letter) async throws -> Letter
}

public struct DefaultRelayLetterUseCase: RelayLetterUseCase {
    private let userRepo: UserRepo
    private let flightRepo: FlightRepo
    private let letterRepo: LetterRepo
    
    init(
        userRepo: UserRepo,
        flightRepo: FlightRepo,
        letterRepo: LetterRepo
    ) {
        self.userRepo = userRepo
        self.flightRepo = flightRepo
        self.letterRepo = letterRepo
    }
    
    func send(
        toNickname: String,
        topic: String,
        topicId: String,
        message: String,
        previousLetter: Letter
    ) async throws -> Letter {
        let fromUid = try await userRepo.currentUserUid()
        let toUid = try await userRepo.fetchUid(nickname: toNickname)
        
        let letter = Letter(
            id: UUID().uuidString,
            fromUid: fromUid,
            toUid: toUid,
            message: message,
            topic: topic,
            topicId: topicId,
            timestamp: Date(),
            isDelivered: false,
            isRelayStart: false
        )
        
        let savedLetter = try await letterRepo.save(letter: letter)
        try await letterRepo.updateIsDelivered(letter: previousLetter)
        try await flightRepo.addRoute(flightId: letter.topicId, letter: savedLetter)
        
        return letter
    }
}
