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
            
            if let previousLetterId = findPreviousLetterId(in: routes, currentLetterId: letter.id) {
                try await letterRepo.updateIsDelivered(letterId: previousLetterId, isDelivered: false)
            }
            
            try await flightRepo.removeRoute(topicId: letter.topicId, routeId: letter.id)
        }
    }
    
    // MARK: - Pure Business Logic Functions 
    
    func findPreviousLetterId(in routes: [[String: Any]], currentLetterId: String) -> String? {
        guard let currentIndex = findLetterIndex(in: routes, letterId: currentLetterId),
              currentIndex > 0 else {
            return nil
        }
        
        let previousRoute = routes[currentIndex - 1]
        return extractLetterId(from: previousRoute)
    }
    
    private func findLetterIndex(in routes: [[String: Any]], letterId: String) -> Int? {
        return routes.firstIndex { route in
            extractLetterId(from: route) == letterId
        }
    }
    
    private func extractLetterId(from route: [String: Any]) -> String? {
        return route["id"] as? String
    }
}
