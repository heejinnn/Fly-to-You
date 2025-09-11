//
//  FirebaseFlightNetworkService.swift
//  Fly to You
//
//  Created by 최희진 on 9/12/25.
//

import Foundation
import FirebaseFirestore
import Alamofire

final class FirebaseFlightNetworkService: FlightNetworkService {
    private let db = Firestore.firestore()
    private let throttlerService: ThrottlerService
    private var flightsListener: ListenerRegistration?
    
    init(throttlerService: ThrottlerService) {
        self.throttlerService = throttlerService
    }
    
    func addRoute(flightId: String, letter: Letter) async throws {
        return try await withCheckedThrowingContinuation{ continuation in
            Task{
                do {
                    let flightRef = db.collection("flights").document(flightId)
                    
                    let document = try await flightRef.getDocument()
                    let routeData = letter.toFirestoreData()
                    
                    if document.exists {
                        try await flightRef.updateData([
                            "routes": FieldValue.arrayUnion([routeData])
                        ])
                        
                        try await self.sendPushNotification(letter: letter)
                    } else {
                        try await flightRef.setData([
                            "id": letter.topicId,
                            "topic": letter.topic,
                            "startDate": letter.timestamp,
                            "routes": [routeData]
                        ])
                        try await self.sendPushNotification(letter: letter)
                        
                        continuation.resume()
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func deleteFlight(topicId: String) async throws {
        let ref = db.collection("flights").document(topicId)
        try await ref.delete()
    }
    
    func removeRoute(topicId: String, routeId: String) async throws {
        let ref = db.collection("flights").document(topicId)
        let routes = try await getRoutes(topicId: topicId)
        
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

extension FirebaseFlightNetworkService {
    private func sendPushNotification(letter: Letter) async throws{
        let firebaseUrl = Bundle.main.infoDictionary?["FirebaseUrl"] as? String ?? ""
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let fromNickname = try await fetchUserNickname(uid: letter.fromUid)
        
        let parameters: [String: String] = [
            "from_id": letter.fromUid,
            "to_id": letter.toUid,
            "title": "Fly to You",
            "body": "\(fromNickname)님이 비행기를 보냈어요!✈️"
        ]
        
        AF.request(firebaseUrl.replacingOccurrences(of: " ", with: ""),
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate()
        .responseDecodable(of: [String: String].self) { response in
            Log.info("[FirebaseFlightNetworkService] - sendPushNotification: \(response.debugDescription)")
        }
    }
    
    private func fetchUserNickname(uid: String) async throws -> String {
        let userRef = db.collection("users").document(uid)
        let userSnapshot = try await userRef.getDocument()
        return userSnapshot.data()?["nickname"] as? String ?? ""
    }
}
