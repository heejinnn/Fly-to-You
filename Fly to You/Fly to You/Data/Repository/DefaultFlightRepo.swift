//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import FirebaseAuth
import FirebaseFirestore

public struct DefaultFlightRepo: FlightRepo {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
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
                "routes": [routeData]
            ])
        }
    }
}
