//
//  RelayLetterUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import Foundation

protocol RelayLetterUseCase{
    func send(toUid: String, topic: String, topicId: String, message: String, previousLetter: Letter) async throws -> Letter
    func fetchReportedCount() async throws -> Bool
}

public struct DefaultRelayLetterUseCase: RelayLetterUseCase {
    private let userRepo: UserRepo
    private let flightRepo: FlightRepo
    private let letterRepo: LetterRepo
    private let sessionService: UserSessionService
    
    init(
        userRepo: UserRepo,
        flightRepo: FlightRepo,
        letterRepo: LetterRepo,
        sessionService: UserSessionService
    ) {
        self.userRepo = userRepo
        self.flightRepo = flightRepo
        self.letterRepo = letterRepo
        self.sessionService = sessionService
    }
    
    func send(
        toUid: String,
        topic: String,
        topicId: String,
        message: String,
        previousLetter: Letter
    ) async throws -> Letter {
        let fromUid = try sessionService.getCurrentUserId()
        
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
        try await letterRepo.updateIsDelivered(letterId: previousLetter.id, isDelivered: true)
        try await flightRepo.addRoute(flightId: savedLetter.topicId, letter: savedLetter)
        try await flightRepo.updateRoute(letter: previousLetter)
        
        return letter
    }
    
    func fetchReportedCount() async throws -> Bool{
        try await userRepo.fetchReportedCount()
    }
}
