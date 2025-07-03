//
//  DeleteLetterUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/19/25.
//


protocol DeleteLetterUseCase {
    func deleteSentLetter(letter: Letter) async throws
}

final class DefaultDeleteLetterUseCase: DeleteLetterUseCase {
    
    private let letterRepo: LetterRepo
    private let flightRepo: FlightRepo
    
    init(letterRepo: LetterRepo, flightRepo: FlightRepo) {
        self.letterRepo = letterRepo
        self.flightRepo = flightRepo
    }
    
    func deleteSentLetter(letter: Letter) async throws {
        // 1. 편지 삭제
        try await letterRepo.deleteSentLetter(letter: letter)
        
        if letter.isRelayStart {
            // 2. flights 문서 삭제
            try await flightRepo.deleteFlight(topicId: letter.topicId)
        } else {
            // 3. routes에서 route 삭제
            let routes = try await flightRepo.getRoutes(topicId: letter.topicId)
            if let currentIndex = routes.firstIndex(where: { ($0["id"] as? String) == letter.id }), currentIndex > 0 {
                let previousRoute = routes[currentIndex - 1]
                if let previousLetterId = previousRoute["id"] as? String {
                    try await letterRepo.updateIsDelivered(letterId: previousLetterId, isDelivered: false)
                }
            }
            try await flightRepo.removeRoute(topicId: letter.topicId, routeId: letter.id)
        }
    }
}
