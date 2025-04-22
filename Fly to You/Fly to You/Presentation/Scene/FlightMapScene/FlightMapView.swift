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

    let flights = [FlightModel(id: UUID().uuidString, topic: "응원", stratDate: Date(), routes: [ReceiveLetterModel(id: "1", from: User(uid: "", nickname: "happy", createdAt: Date()), to: User(uid: "", nickname: "ddd", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: true, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "ddd", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sad", createdAt: Date()), to: User(uid: "", nickname: "sss", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sss", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sss", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sss", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false)])]
    
    @State private var selectedFlightId: String? = nil
    
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
                
                
                ForEach(flights, id: \.id) { flight in
                    PlaneCell(letter: flight.routes[0], route: .receive)
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
            let flights: [FlightModel] = documents.compactMap { doc in
                try? doc.data(as: FlightModel.self)
            }
            DispatchQueue.main.async {
                self.flights = flights
            }
        }
    }
}
