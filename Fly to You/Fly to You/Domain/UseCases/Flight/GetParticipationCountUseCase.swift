//
//  GetParticipationCountUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 8/16/25.
//

import Foundation

protocol GetParticipationCountUseCase {
    func execute(for flight: FlightModel) -> Int
}

final class DefaultGetParticipationCountUseCase: GetParticipationCountUseCase {
    
    func execute(for flight: FlightModel) -> Int {
        let uniqueParticipants = extractUniqueParticipants(from: flight)
        return uniqueParticipants.count
    }
    
    // MARK: - Private Methods
    private func extractUniqueParticipants(from flight: FlightModel) -> Set<String> {
        var uniqueParticipants = Set<String>()
        
        for route in flight.routes {
            uniqueParticipants.insert(route.from.uid)
        }
        
        return uniqueParticipants
    }
}