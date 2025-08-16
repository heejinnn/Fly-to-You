//
//  FlightAnalysisService.swift
//  Fly to You
//
//  Created by 최희진 on 8/16/25.
//

import Foundation

// Domain Layer - 비즈니스 로직을 담당하는 서비스
protocol FlightAnalysisService {
    func calculateParticipationCount(for flight: FlightModel) -> Int
    func analyzeFlightActivity(for flight: FlightModel) -> FlightAnalysisResult
}

struct FlightAnalysisResult {
    let participationCount: Int
    let totalRoutes: Int
    let isActiveRoute: Bool
    let uniqueParticipants: Set<String>
}

final class DefaultFlightAnalysisService: FlightAnalysisService {
    
    func calculateParticipationCount(for flight: FlightModel) -> Int {
        let uniqueParticipants = extractUniqueParticipants(from: flight)
        return uniqueParticipants.count
    }
    
    func analyzeFlightActivity(for flight: FlightModel) -> FlightAnalysisResult {
        let uniqueParticipants = extractUniqueParticipants(from: flight)
        let totalRoutes = flight.routes.count
        let isActive = totalRoutes > 0 && hasRecentActivity(flight)
        
        return FlightAnalysisResult(
            participationCount: uniqueParticipants.count,
            totalRoutes: totalRoutes,
            isActiveRoute: isActive,
            uniqueParticipants: uniqueParticipants
        )
    }
    
    // MARK: - Private Methods
    private func extractUniqueParticipants(from flight: FlightModel) -> Set<String> {
        var uniqueParticipants = Set<String>()
        
        for route in flight.routes {
            uniqueParticipants.insert(route.from.uid)
        }
        
        return uniqueParticipants
    }
    
    private func hasRecentActivity(_ flight: FlightModel) -> Bool {
        let dayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        return flight.routes.contains { $0.timestamp > dayAgo }
    }
}