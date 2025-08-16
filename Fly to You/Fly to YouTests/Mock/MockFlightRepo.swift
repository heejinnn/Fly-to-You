//
//  MockLetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 8/16/25.
//

@testable import Fly_to_You

class DummyFlightRepo: FlightRepo {
    func addRoute(flightId: String, letter: Fly_to_You.Letter) async throws {}
    func deleteFlight(topicId: String) async throws {   }
    func removeRoute(topicId: String, routeId: String) async throws {}
    func updateRoute(letter: Fly_to_You.Letter) async throws {}
    func getRoutes(topicId: String) async throws -> [[String : Any]] {
        return [[:]]
    }
    
    func observeAllFlights(onUpdate: @escaping ([Fly_to_You.FlightDto]) -> Void) {}
    func removeFlightsListener() {}
    
}
