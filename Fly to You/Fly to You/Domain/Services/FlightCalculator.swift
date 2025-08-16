//
//  FlightCalculator.swift
//  Fly to You
//
//  Created by 최희진 on 8/16/25.
//

import Foundation

protocol FlightCalculatorProtocol {
    func calculateParticipationCount(for flight: FlightModel) -> Int
    func calculateTotalRoutes(for flight: FlightModel) -> Int
    func findUniqueParticipants(for flight: FlightModel) -> Set<String>
}

final class FlightCalculator: FlightCalculatorProtocol {
    
    func calculateParticipationCount(for flight: FlightModel) -> Int {
        return findUniqueParticipants(for: flight).count
    }
    
    func calculateTotalRoutes(for flight: FlightModel) -> Int {
        return flight.routes.count
    }
    
    func findUniqueParticipants(for flight: FlightModel) -> Set<String> {
        var uniqueUsers = Set<String>()
        
        for route in flight.routes {
            uniqueUsers.insert(route.from.uid)
        }
        
        return uniqueUsers
    }
}