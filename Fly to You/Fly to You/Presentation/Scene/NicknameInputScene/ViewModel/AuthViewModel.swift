//
//  AuthViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var nicknameDuplicateError: Bool = false
    
    private let db = Firestore.firestore()

    func trySignUp() {
        checkNicknameDuplicate(nickname: nickname) { [weak self] isDuplicate in
            guard let self = self else { return }
            if isDuplicate {
                self.nicknameDuplicateError = true
                print("닉네임 중복됨")
            } else {
                self.nicknameDuplicateError = false
                self.signInAnonymouslyAndSaveUser()
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

    private func signInAnonymouslyAndSaveUser() {
        Auth.auth().signInAnonymously { [weak self] result, error in
            guard let self = self, let uid = result?.user.uid else { return }

            let user = UserModel(uid: uid, nickname: self.nickname, createdAt: Date())

            do {
                try self.db.collection("users").document(uid).setData(from: user) { error in
                    if error == nil {
                        UserDefaults.standard.set(uid, forKey: "uid")
                        self.isLoggedIn = true
                    }
                }
            } catch {
                print("유저 저장 에러: \(error.localizedDescription)")
            }
        }
    }
}
