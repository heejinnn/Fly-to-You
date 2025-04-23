//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import FirebaseAuth
import FirebaseFirestore

final class DefaultFlightRepo: FlightRepo {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private var flightsListener: ListenerRegistration?
    
    func addRoute(flightId: String, letter: Letter) async throws {
        let flightRef = db.collection("flights").document(flightId)
        
        let document = try await flightRef.getDocument()
        let routeData = letter.toFirestoreData()

        if document.exists {
            // 이미 있으면 updateData
            try await flightRef.updateData([
                "routes": FieldValue.arrayUnion([routeData])
            ])
        } else {
            // 없으면 setData로 새로 생성
            try await flightRef.setData([
                "id": letter.topicId,
                "topic": letter.topic,
                "startDate": letter.timestamp,
                "routes": [routeData]
            ])
        }
    }
    
    func deleteFlight(topicId: String) async throws {
        let ref = db.collection("flights").document(topicId)
        try await ref.delete()
    }
    
    func removeRoute(topicId: String, routeId: String) async throws {
        let ref = db.collection("flights").document(topicId)
        let routes = try await getRoutes(topicId: topicId)
        
        // routes 배열에서 해당 route만 삭제
        if let route = routes.first(where: { $0["id"] as? String == routeId }) {
            try await ref.updateData([
                "routes": FieldValue.arrayRemove([route])
            ])
        }
    }
    
    func updateRoute(letter: Letter) async throws {
        let ref = db.collection("flights").document(letter.topicId)
        
        _ = try await db.runTransaction { transaction, errorPointer in
            do {
                let document = try transaction.getDocument(ref)
                var routes = document.data()?["routes"] as? [[String: Any]] ?? []
                
                if let index = routes.firstIndex(where: { $0["id"] as? String == letter.id }) {
                    let routeData = letter.toFirestoreDataDeliver()
                    
                    // 필수 필드 체크
                    guard routeData["toUid"] != nil, routeData["fromUid"] != nil else {
                        throw NSError(domain: "FlightError", code: 0, userInfo: [NSLocalizedDescriptionKey: "필수 필드 누락"])
                    }
                    
                    routes[index] = routeData
                    transaction.updateData(["routes": routes], forDocument: ref)
                }
                return nil
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
        }
    }

    
    func getRoutes(topicId: String) async throws -> [[String: Any]] {
        let flightRef = db.collection("flights").document(topicId)
        let flightDoc = try await flightRef.getDocument()
        return flightDoc.data()?["routes"] as? [[String: Any]] ?? []
    }
    
    func observeAllFlights(onUpdate: @escaping ([FlightDto]) -> Void) {
        flightsListener?.remove()
        
        flightsListener = db.collection("flights")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    onUpdate([])
                    return
                }
                let dtos: [FlightDto] = documents.compactMap { try? $0.data(as: FlightDto.self) }
                onUpdate(dtos)
            }
    }
    
    func removeFlightsListener() {
        flightsListener?.remove()
        flightsListener = nil
    }
}
