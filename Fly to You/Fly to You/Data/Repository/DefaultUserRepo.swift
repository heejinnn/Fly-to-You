//
//  DefaultSendLetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import FirebaseAuth
import FirebaseFirestore

struct DefaultUserRepo: UserRepo {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func fetchUid(nickname: String) async throws -> String {
        let query = db.collection("users")
            .whereField("nickname", isEqualTo: nickname)
            .limit(to: 1)
        
        let snapshot = try await query.getDocuments()
        
        guard let document = snapshot.documents.first else {
            throw FirebaseError.validationError(message: "사용자를 찾을 수 없음")
        }
        
        return document.documentID
    }
    
    func currentUserUid() async throws -> String {
        guard let user = auth.currentUser else {throw
            FirebaseError.validationError(message: "로그인 필요")
        }
        return user.uid
    }
}


