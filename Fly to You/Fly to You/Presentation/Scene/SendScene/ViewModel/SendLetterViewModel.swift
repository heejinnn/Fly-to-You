//
//  SendLetterViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SendLetterViewModel: ObservableObject{
    
    func sendLetter(toUID: String, topic: String, message: String, completion: @escaping (Error?) -> Void) {
        guard let fromUID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인 필요"]))
            return
        }

        let topicId = UUID().uuidString
        let db = Firestore.firestore()
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
                let flightRef = db.collection("flights").document(topicId)
                let routeData: [String: Any] = [
                    "fromUID": fromUID,
                    "toUID": toUID,
                    "timestamp": Timestamp(date: Date()),
                    "topicId": topicId
                ]

                flightRef.getDocument { snapshot, error in
                    if let snapshot = snapshot, snapshot.exists {
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
