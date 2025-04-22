//
//  FlightMapView.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import SwiftUI

struct FlightMapView: View{
    
    private let segmentedMenu = ["진행 중인 항로", "완료된 항로"]
    @State private var selectedTab = "진행 중인 항로"

//    let flights = [FlightModel(id: UUID().uuidString, topic: "응원", stratDate: Date(), routes: [ReceiveLetterModel(id: "1", from: User(uid: "", nickname: "happy", createdAt: Date()), to: User(uid: "", nickname: "ddd", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: true, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "ddd", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sad", createdAt: Date()), to: User(uid: "", nickname: "sss", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sss", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sss", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sss", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false)])]
    
    @State private var selectedFlightId: String? = nil
    @StateObject var viewModel = FlightViewModel()
    
    var body: some View{
        ScrollView{
            VStack(spacing: Spacing.md){
                
                Spacer()
                
                Text("종이 비행기의 여행 경로를 확인해 보세요")
                    .font(.pretendard(.medium, size: 15))
                    .foregroundStyle(.gray3)
                
                Picker("", selection: $selectedTab){
                    ForEach(segmentedMenu, id: \.self){
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, Spacing.md)
                
                
                ForEach(viewModel.flights, id: \.id) { flight in
                    PlaneCell(letter: flight.routes[0], participantCount: flight.routes.count, route: .map)
                        .onTapGesture {
                            if selectedFlightId == flight.id {
                                selectedFlightId = nil
                            } else {
                                selectedFlightId = flight.id
                            }
                        }
                    
                    if selectedFlightId == flight.id {
                        FlightMapCell(flight: flight)
                    }
                }
                
                Spacer()
            }
        }
        .onAppear{
            viewModel.fetchAllFlights()
        }
    }
}

#Preview {
    FlightMapView()
}

final class FlightMapViewModelWrapper: ObservableObject{
    
}


import FirebaseFirestore

final class FlightViewModel: ObservableObject {
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
                        let routeModels = dto.routes.map { routeDTO in
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
