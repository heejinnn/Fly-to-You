//
//  DefaultSignUpRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import FirebaseAuth
import FirebaseFirestore

final class DefaultSignUpRepo: SignUpRepo {
    
    private let db = Firestore.firestore()
    
    func signUp(nickname: String, completion: @escaping (Bool) -> Void) {
        checkNicknameDuplicate(nickname: nickname) { [weak self] isDuplicate in
            guard let self = self else { return }
            if isDuplicate {
                print("닉네임 중복됨")
                completion(false)
            } else {
                self.signInAnonymouslyAndSaveUser(nickname: nickname){ result in
                    if result {
                        completion(true)
                    }
                }
            }
        }
    }
    
    private func checkNicknameDuplicate(nickname: String, completion: @escaping (Bool) -> Void) {
        db.collection("users")
            .whereField("nickname", isEqualTo: nickname)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("중복 검사 오류: \(error.localizedDescription)")
                    completion(true)
                    return
                }
                let isDuplicated = snapshot?.documents.isEmpty == false
                completion(isDuplicated)
            }
    }

    private func signInAnonymouslyAndSaveUser(nickname: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signInAnonymously { [weak self] result, error in
            guard let self = self, let uid = result?.user.uid else { return }

            let user = User(uid: uid, nickname: nickname, createdAt: Date())

            do {
                try self.db.collection("users").document(uid).setData(from: user) { error in
                    if error == nil {
                        UserDefaults.standard.set(uid, forKey: "uid")
                        completion(true)
                    }
                }
            } catch {
                print("유저 저장 에러: \(error.localizedDescription)")
            }
        }
    }
}
