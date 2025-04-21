//
//  DefaultSendLetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import FirebaseAuth
import FirebaseFirestore

final class DefaultUserRepo: UserRepo {
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
    
    func fetchUsers(uids: [String]) async throws -> [User] {
        guard !uids.isEmpty else { return [] }
        
        // 10개씩 청크 분할
        let chunks = uids.chunked(into: 10)
        var users: [User] = []
        
        for chunk in chunks {
            let snapshot = try await db.collection("users")
                .whereField("uid", in: chunk)
                .getDocuments()
            
            let chunkUsers = snapshot.documents.compactMap { doc in
                try? doc.data(as: User.self)
            }
            users += chunkUsers
        }
        
        return users
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        } 
    }
}

