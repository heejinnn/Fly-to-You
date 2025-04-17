//
//  RelayLetterUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import Foundation

protocol RelayLetterUseCase{
    func send(toNickname: String, topic: String, topicId: String, message: String) async throws -> Letter
}

public struct DefaultRelayLetterUseCase: RelayLetterUseCase {
    private let userRepo: UserRepo
    private let flightRepo: FlightRepo
    
    init(
        userRepo: UserRepo,
        flightRepo: FlightRepo
    ) {
        self.userRepo = userRepo
        self.flightRepo = flightRepo
    }
    
    func send(
        toNickname: String,
        topic: String,
        topicId: String,
        message: String
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
            timestamp: Date()
        )
        
        try await flightRepo.addRoute(flightId: letter.topicId, letter: letter)
        
        return letter
    }
}
