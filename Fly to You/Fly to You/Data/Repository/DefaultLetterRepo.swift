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
        let letterRef = db.collection("letters").document(letter.topicId)
        let document = try await letterRef.getDocument()
        let newLetter = letter.toFirestoreData()

        if document.exists {
            try await letterRef.updateData(newLetter)
        }
        return letter.toReceiveLetterDto(data: letter)
    }
    
    func deleteSentLetter(letter: Letter) async throws {
        // 1. letters 컬렉션에서 해당 편지 삭제
        let letterRef = db.collection("letters").document(letter.topicId)
        try await letterRef.delete()
        
        // 2. 해당 letter를 가진 flights 문서들 찾기 (직접 쿼리할 수 있는 인덱스가 있다면)
        let flightsQuery = db.collection("flights")
        let flightsDocs = try await flightsQuery.getDocuments()
        
        // 편지 데이터를 Firestore 형식으로 변환
        let routeData = letter.toFirestoreData()
        
        if letter.isRelayStart {
            let flightRef = db.collection("flights").document(letter.topicId)
            try await flightRef.delete()
        } else{
            // 3. 각 flight 문서에서 해당 route 제거
            for document in flightsDocs.documents {
                try await document.reference.updateData([
                    "routes": FieldValue.arrayRemove([routeData])
                ])
            }
        }
    }
}
