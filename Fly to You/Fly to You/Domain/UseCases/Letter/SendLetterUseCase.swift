//
//  SendLetterUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import Foundation


protocol SendLetterUseCase{
    func send(toUid: String, topic: String, topicId: String, message: String) async throws -> Letter
    func fetchReportedCount() async throws -> Bool
}

public struct DefaultSendLetterUseCase: SendLetterUseCase {
    private let userRepo: UserRepo
    private let letterRepo: LetterRepo
    private let flightRepo: FlightRepo
    
    init(
        userRepo: UserRepo,
        letterRepo: LetterRepo,
        flightRepo: FlightRepo
    ) {
        self.userRepo = userRepo
        self.letterRepo = letterRepo
        self.flightRepo = flightRepo
    }
    
    func send(
        toUid: String,
        topic: String,
        topicId: String,
        message: String
    ) async throws -> Letter {
        let fromUid = try await userRepo.currentUserUid()
        
        let letter = Letter(
            id: UUID().uuidString,
            fromUid: fromUid,
            toUid: toUid,
            message: message,
            topic: topic,
            topicId: topicId,
            timestamp: Date(),
            isDelivered: false,
            isRelayStart: true
        )
        
        let savedLetter = try await letterRepo.save(letter: letter)
        try await flightRepo.addRoute(flightId: savedLetter.topicId, letter: savedLetter)
        
        return savedLetter
    }
    
    func fetchReportedCount() async throws -> Bool{
        try await userRepo.fetchReportedCount()
    }
}
