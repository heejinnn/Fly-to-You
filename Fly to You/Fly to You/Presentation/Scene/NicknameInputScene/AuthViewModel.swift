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
    
    private let db = Firestore.firestore()
    
    func signInAnonymouslyAndSaveUser() {
        Auth.auth().signInAnonymously { [weak self] result, error in
            if let error = error {
                print("로그인 오류: \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid, let self = self else { return }
            print(uid)
            let user = UserModel(uid: uid, nickname: self.nickname, createdAt: Date())
            
            do {
                try self.db.collection("users").document(uid).setData(from: user) { error in
                    if let error = error {
                        print("유저 저장 오류: \(error.localizedDescription)")
                        return
                    }
                    
                    UserDefaults.standard.set(uid, forKey: "uid")
                    self.isLoggedIn = true
                    print("로그인 및 유저 저장 완료")
                }
            } catch {
                print("인코딩 오류: \(error.localizedDescription)")
            }
        }
    }
}
