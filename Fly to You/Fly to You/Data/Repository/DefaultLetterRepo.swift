//
//  DefaultLetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import FirebaseFirestore

public struct DefaultLetterRepo: LetterRepo {
    private let db = Firestore.firestore()
    
    func save(letter: Letter) async throws -> Letter {
        let document = db.collection("letters").document(letter.id)
        try await document.setData(letter.toFirestoreData())
        return letter
    }
    
    func updateIsDelivered(letter: Letter) async throws {
        let document = db.collection("letters").document(letter.id)
        try await document.updateData([
            "isDelivered": true
        ])
    }
    
    func fetchReceivedLetters(toUid: String) async throws -> [ReceiveLetterDto] {
        let snapshot = try await db.collection("letters")
            .whereField("toUid", isEqualTo: toUid)
            .whereField("isDelivered", isEqualTo: false)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: ReceiveLetterDto.self)
        }
    }
    
    func fetchSentLetters(fromUid: String) async throws -> [ReceiveLetterDto] {
        let snapshot = try await db.collection("letters")
            .whereField("fromUid", isEqualTo: fromUid)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: ReceiveLetterDto.self)
        }
    }
    
    func editSentLetter(letter: Letter) async throws -> ReceiveLetterDto {
        let letterRef = db.collection("letters").document(letter.id)
        let document = try await letterRef.getDocument()
        let newLetter = letter.toFirestoreData()

        if document.exists {
            try await letterRef.updateData(newLetter)
        }
        return letter.toReceiveLetterDto(data: letter)
    }
    
    func deleteSentLetter(letter: Letter) async throws {
        // 1. letters 컬렉션에서 해당 편지 삭제
        let letterRef = db.collection("letters").document(letter.id)
        try await letterRef.delete()

        // 2. flights 컬렉션에서 해당 flight 문서(routes 배열만 필요)
        let flightRef = db.collection("flights").document(letter.topicId)
        let flightDoc = try await flightRef.getDocument()
        guard var routes = flightDoc.data()?["routes"] as? [[String: Any]] else { return }
        
        if letter.isRelayStart {
            // 릴레이 시작점이면 flight 문서 자체 삭제
            try await flightRef.delete()
        } else {
            // 3. routes 배열에서 해당 routeData 삭제
            try await flightDoc.reference.updateData([
                "routes": routes.removeLast()
            ])
            
            // 4. 삭제한 routeData 앞 순서에 저장된 routes 경로가 있으면 isDelivered 필드 수정
            if let currentIndex = routes.firstIndex(where: { ($0["id"] as? String) == letter.id }), currentIndex > 0 {
                let previousRoute = routes[currentIndex - 1]
                if let previousLetterId = previousRoute["id"] as? String {
                    let previousLetterRef = db.collection("letters").document(previousLetterId)
                    try await previousLetterRef.updateData([
                        "isDelivered": false
                    ])
                }
            }
        }
    }
}
