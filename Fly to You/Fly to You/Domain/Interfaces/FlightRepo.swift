//
//  FlightRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

protocol FlightRepo{
    func addRoute(flightId: String, letter: Letter) async throws
    func deleteFlight(topicId: String) async throws
    func removeRoute(topicId: String, routeId: String) async throws
    func updateRoute(letter: Letter) async throws
    func getRoutes(topicId: String) async throws -> [[String: Any]]
    func observeAllFlights(onUpdate: @escaping ([FlightDto]) -> Void)
    func removeFlightsListener()
}
