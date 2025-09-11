//
//  DefaultFlightRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import Foundation

final class DefaultFlightRepo: FlightRepo {
    private let flightNetworkService: FlightNetworkService
    
    init(flightNetworkService: FlightNetworkService) {
        self.flightNetworkService = flightNetworkService
    }

    func addRoute(flightId: String, letter: Letter) async throws {
        try await flightNetworkService.addRoute(flightId: flightId, letter: letter)
    }
    
    func deleteFlight(topicId: String) async throws {
        try await flightNetworkService.deleteFlight(topicId: topicId)
    }
    
    func removeRoute(topicId: String, routeId: String) async throws {
        try await flightNetworkService.removeRoute(topicId: topicId, routeId: routeId)
    }
    
    func updateRoute(letter: Letter) async throws {
        try await flightNetworkService.updateRoute(letter: letter)
    }
    
    func getRoutes(topicId: String) async throws -> [[String: Any]] {
        return try await flightNetworkService.getRoutes(topicId: topicId)
    }
    
    func observeAllFlights(onUpdate: @escaping ([FlightDto]) -> Void) {
        flightNetworkService.observeAllFlights(onUpdate: onUpdate)
    }
    
    func removeFlightsListener() {
        flightNetworkService.removeFlightsListener()
    }
}