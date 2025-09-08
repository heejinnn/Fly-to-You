//
//  DefaultSignUpRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import FirebaseFirestore
import FirebaseAuth


final class DefaultSignUpRepo: SignUpRepo {
    
    private let db = Firestore.firestore()
    private let sessionService: UserSessionService
    
    init(sessionService: UserSessionService) {
        self.sessionService = sessionService
    }
    
    func signUp(nickname: String, completion: @escaping (Bool) -> Void) {
        checkNicknameDuplicate(nickname: nickname) { [weak self] isDuplicate in
            guard let self = self else { return }
            if isDuplicate {
                Log.debug("닉네임이 중복됨")
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
                    Log.error("\("중복 검사 오류: \(error.localizedDescription)")")
                    completion(true)
                    return
                }
                let isDuplicated = snapshot?.documents.isEmpty == false
                completion(isDuplicated)
            }
    }

    private func signInAnonymouslyAndSaveUser(nickname: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signInAnonymously { [weak self] result, error in
            guard let self = self, let uid = result?.user.uid, let fcmToken = KeychainTokenStorage.load(for: "fcmToken") else { return }
            
            let user = User(uid: uid, nickname: nickname, createdAt: Date(), fcmToken: fcmToken, reportedCount: 0, blockedLetters: [])
            
            do {
                try self.db.collection("users")
                    .document(uid)
                    .setData(from: user) { [weak self] error in
                    if error == nil {
                        self?.sessionService.saveUserSession(uid: uid, nickname: nickname.lowercased())
                        completion(true)
                    }
                }
            } catch {
                Log.error("유저 저장 에러: \(error.localizedDescription)")
            }
        }
    }
}
