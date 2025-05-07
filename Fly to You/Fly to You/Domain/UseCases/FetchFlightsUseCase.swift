//
//  FetchFlightsUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import SwiftUI

protocol FetchFlightsUseCase{
    func observeAllFlights(onUpdate: @escaping ([FlightModel]) -> Void)
    func removeFlightsListener()
}

final class DefaultFetchFlightsUseCase: FetchFlightsUseCase {
    
    private let userRepo: UserRepo
    private let flightRepo: FlightRepo
    
    init(userRepo: UserRepo, flightRepo: FlightRepo) {
        self.userRepo = userRepo
        self.flightRepo = flightRepo
    }
    
    func observeAllFlights(onUpdate: @escaping ([FlightModel]) -> Void) {
        flightRepo.observeAllFlights { [weak self] dtos in
            guard let self = self else { return }
            Task {
                let sortedDtos = dtos.sorted { $0.startDate > $1.startDate }
                
                // 1. 모든 사용자 ID 추출
                let userIDs = Set(
                    sortedDtos.flatMap { $0.routes.flatMap { [$0.fromUid, $0.toUid] } }
                )
                
                // 2. 사용자 정보 일괄 조회
                let users = try? await self.userRepo.fetchUsers(uids: Array(userIDs))
                let usersByID = users.map { Dictionary(uniqueKeysWithValues: $0.map { ($0.uid, $0) }) } ?? [:]
                
                // 3. DTO → Model 변환
                let models: [FlightModel] = sortedDtos.map { dto in
                    let sortedRoutes = dto.routes.sorted { $0.timestamp < $1.timestamp }
                    let routeModels = sortedRoutes.map { routeDTO in
                        ReceiveLetterModel(
                            id: routeDTO.id,
                            from: usersByID[routeDTO.fromUid] ?? .unknown,
                            to: usersByID[routeDTO.toUid] ?? .unknown,
                            message: routeDTO.message,
                            topic: routeDTO.topic,
                            topicId: routeDTO.topicId,
                            timestamp: routeDTO.timestamp,
                            isDelivered: routeDTO.isDelivered,
                            isRelayStart: routeDTO.isRelayStart
                        )
                    }
                    return FlightModel(
                        id: dto.id,
                        topic: dto.topic,
                        startDate: dto.startDate,
                        routes: routeModels
                    )
                }
                DispatchQueue.main.async {
                    onUpdate(models)
                }
            }
        }
    }
    
    func removeFlightsListener() {
        flightRepo.removeFlightsListener()
    }
}
