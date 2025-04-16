//
//  DefaultLetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import FirebaseAuth
import FirebaseFirestore

public struct DefaultLetterRepo: LetterRepo {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func save(letter: Letter) async throws -> Letter {
        let document = db.collection("letters").document(letter.topicId)
        try await document.setData(letter.toFirestoreData())
        return letter
    }
}
