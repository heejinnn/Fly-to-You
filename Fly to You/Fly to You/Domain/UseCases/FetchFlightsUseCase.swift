//
//  FetchFlightsUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

protocol FetchFlightsUseCase{
    func execute() async throws -> [FlightModel]
}

final class DefaultFetchFlightsUseCase: FetchFlightsUseCase {
    
    private let userRepo: UserRepo
    private let flightRepo: FlightRepo
    
    init(userRepo: UserRepo, flightRepo: FlightRepo) {
        self.userRepo = userRepo
        self.flightRepo = flightRepo
    }
    
    func execute() async throws -> [FlightModel] {
        // 1. FlightDTO 목록 가져오기
        let flightDtos = try await flightRepo.fetchAllFlights()
        
        // 2. 모든 사용자 ID 추출
        let userIDs = Set(
            flightDtos.flatMap { $0.routes.flatMap { [$0.fromUid, $0.toUid] } }
        )
        
        // 3. 사용자 정보 일괄 조회
        let users = try await userRepo.fetchUsers(uids: Array(userIDs))
        let usersByID = Dictionary(uniqueKeysWithValues: users.map { ($0.uid, $0) })
        
        // 4. DTO → Model 변환
        return flightDtos.map { dto in
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
    }
}
