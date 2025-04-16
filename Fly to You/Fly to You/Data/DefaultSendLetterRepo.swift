//
//  DefaultSendLetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import FirebaseAuth
import FirebaseFirestore

final class DefaultSendLetterRepo: SendLetterRepo {
    
    private let db = Firestore.firestore()
    
    func sendLetter(toUID: String, topic: String, topicId: String, message: String, completion: @escaping (Error?) -> Void) {
        guard let fromUID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인 필요"]))
            return
        }

        let letterRef = db.collection("letters").document()

        let letterData: [String: Any] = [
            "id": letterRef.documentID,
            "fromUID": fromUID,
            "toUID": toUID,
            "topic": topic,
            "topicId": topicId,
            "message": message,
            "timestamp": Timestamp(date: Date())
        ]

        letterRef.setData(letterData) { error in
            if let error = error {
                completion(error)
            } else {
                let flightRef = self.db.collection("flights").document(topicId)
                let routeData: [String: Any] = [
                    "fromUID": fromUID,
                    "toUID": toUID,
                    "timestamp": Timestamp(date: Date()),
                    "topicId": topicId
                ]

                flightRef.getDocument { document, error in
                    if let document = document, document.exists {
                        // 이미 문서가 있으면 업데이트
                        flightRef.updateData([
                            "routes": FieldValue.arrayUnion([routeData])
                        ]) { err in
                            completion(err)
                        }
                    } else {
                        // 없으면 새로 생성
                        flightRef.setData([
                            "routes": [routeData]
                        ]) { err in
                            completion(err)
                        }
                    }
                }
            }
        }
    }
}
