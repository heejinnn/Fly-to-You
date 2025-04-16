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

public struct DefaultLetterRepo: LetterRepo {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func save(letter: Letter) async throws -> Letter {
        let document = db.collection("letters").document(letter.topicId)
        try await document.setData(letter.toFirestoreData())
        return letter
    }
}

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


public enum FirebaseError: LocalizedError {
    case validationError(message: String)
    case repositoryError(cause: Error)
    
    public var errorDescription: String? {
        switch self {
        case .validationError(let msg): return msg
        case .repositoryError(let cause): return cause.localizedDescription
        }
    }
}


