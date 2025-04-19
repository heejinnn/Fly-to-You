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
        let document = db.collection("letters").document(letter.topicId)
        try await document.setData(letter.toFirestoreData())
        return letter
    }
    
    func updateIsDelivered(letter: Letter) async throws {
        let document = db.collection("letters").document(letter.topicId)
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
}
