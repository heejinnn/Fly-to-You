//
//  FlightMapViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import FirebaseFirestore

protocol FlightMapViewModelInput {

}

protocol FlightMapViewModelOutput {
    
}

protocol FlightMapViewModel: FlightMapViewModelInput, FlightMapViewModelOutput {}


final class DefaultFlightMapViewModel: FlightMapViewModel {
    @Published var flights: [FlightModel] = []
    private let db = Firestore.firestore()

    func fetchAllFlights() {
        db.collection("flights").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("flights 가져오기 실패: \(error?.localizedDescription ?? "")")
                return
            }
            
            let flightDTOs: [FlightDTO] = documents.compactMap {
                try? $0.data(as: FlightDTO.self)
            }
            
            // 유저 UID만 추출
            let userIDs = Set(
                flightDTOs.flatMap { $0.routes.flatMap { [$0.fromUid, $0.toUid] } }
            )

            Task {
                do {
                    let users = try await self.fetchUsers(uids: Array(userIDs))
                    let usersByID = Dictionary(uniqueKeysWithValues: users.map { ($0.uid, $0) })

                    let flightModels: [FlightModel] = flightDTOs.map { dto in
                        
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
                            stratDate: dto.startDate,
                            routes: routeModels
                        )
                    }

                    DispatchQueue.main.async {
                        self.flights = flightModels
                        print(self.flights)
                    }

                } catch {
                    print("유저 정보 가져오기 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchUsers(uids: [String]) async throws -> [User] {
        guard !uids.isEmpty else { return [] }

        let chunks = uids.chunked(into: 10)
        var allUsers: [User] = []

        for chunk in chunks {
            let snapshot = try await db.collection("users")
                .whereField("uid", in: chunk)
                .getDocuments()

            let users = snapshot.documents.compactMap { doc in
                try? doc.data(as: User.self)
            }
            allUsers += users
        }

        return allUsers
    }
}

struct FlightDTO: Codable {
    let id: String
    let topic: String
    let startDate: Date
    let routes: [ReceiveLetterDTO]
}

struct ReceiveLetterDTO: Codable {
    let id: String
    let fromUid: String
    let toUid: String
    let message: String
    let topic: String
    let topicId: String
    let timestamp: Date
    let isDelivered: Bool
    let isRelayStart: Bool
}
extension User {
    static let unknown = User(uid: "unknown", nickname: "(Unknown)", createdAt: Date())
}
