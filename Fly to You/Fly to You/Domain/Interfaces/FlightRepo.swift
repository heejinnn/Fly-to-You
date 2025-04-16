//
//  FlightRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

protocol FlightRepo{
    func addRoute(flightId: String, letter: Letter) async throws
}
