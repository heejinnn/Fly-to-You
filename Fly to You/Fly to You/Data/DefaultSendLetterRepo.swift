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
    
    func sendLetter(toText: String, topic: String, topicId: String, message: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let fromUid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인 필요"])))
            return
        }

        fetchUID(fromNickname: toText) { result in
            switch result {
            case .success(let toUid):
                
                print("[DefaultSendLetterRepo] - uid 찾기 성공")
                
                self.saveLetter(fromUid: fromUid, toUid: toUid, topic: topic, topicId: topicId, message: message) { letterResult in
                    switch letterResult {
                    case .success(let letterData):
                        
                        print("[DefaultSendLetterRepo] - 비행기 저장 성공")
                        
                        self.saveFlightRoute(letterData: letterData) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                completion(.success("success"))
                                
                                print("[DefaultSendLetterRepo] - 비행기 경로 저장 성공")
                            }
                        }

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func fetchUID(fromNickname nickname: String, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection("users")
            .whereField("nickname", isEqualTo: nickname)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let document = snapshot?.documents.first else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "해당 닉네임의 사용자를 찾을 수 없습니다"])))
                    return
                }

                completion(.success(document.documentID))
            }
    }

    private func saveLetter(fromUid: String, toUid: String, topic: String, topicId: String, message: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let letterRef = db.collection("letters").document()
        let letterId = letterRef.documentID
        let letterData: [String: Any] = [
            "id": letterId,
            "fromUid": fromUid,
            "toUid": toUid,
            "topic": topic,
            "topicId": topicId,
            "message": message,
            "timestamp": Timestamp(date: Date())
        ]

        letterRef.setData(letterData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(letterData))
            }
        }
    }

    private func saveFlightRoute(letterData: [String:Any], completion: @escaping (Error?) -> Void) {
        let flightRef = db.collection("flights").document(letterData["topicId"] as! String)

        flightRef.getDocument { document, error in
            if let document = document, document.exists {
                flightRef.updateData([
                    "routes": FieldValue.arrayUnion([letterData])
                ], completion: completion)
            } else {
                flightRef.setData([
                    "routes": [letterData]
                ], completion: completion)
            }
        }
    }
}
