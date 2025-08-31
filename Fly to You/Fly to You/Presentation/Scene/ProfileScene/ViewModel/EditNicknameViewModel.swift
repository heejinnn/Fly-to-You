//
//  EditNicknameViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 7/10/25.
//

import Foundation
import FirebaseFirestore

final class EditNicknameViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var duplicateError: Bool = false

    private let db = Firestore.firestore()
    private let sessionService: UserSessionService
    
    init(sessionService: UserSessionService) {
        self.sessionService = sessionService
    }

    func updateNickname(completion: @escaping (Bool) -> Void) {
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        checkNicknameDuplicate(nickname: trimmed) { [weak self] isDuplicate in
            guard let self = self else { return }

            if isDuplicate {
                self.duplicateError = true
                return
            }

            do {
                let uid = try sessionService.getCurrentUserId()
                
                db.collection("users").document(uid).updateData([
                    "nickname": trimmed
                ]) { [weak self] error in
                    if let error = error {
                        Log.error("닉네임 업데이트 실패: \(error)")
                        completion(false)
                        return
                    }

                    self?.sessionService.saveUserSession(uid: uid, nickname: trimmed)
                    self?.duplicateError = false
                    completion(true)
                }
            } catch {
                Log.error("Session error: \(error.localizedDescription)")
                completion(false)
            }
        }
        completion(false)
    }

    private func checkNicknameDuplicate(nickname: String, completion: @escaping (Bool) -> Void) {
        db.collection("users")
            .whereField("nickname", isEqualTo: nickname)
            .getDocuments { snapshot, error in
                if let error = error {
                    Log.error("중복 검사 오류: \(error.localizedDescription)")
                    completion(true)
                    return
                }
                let isDuplicated = snapshot?.documents.isEmpty == false
                completion(isDuplicated)
            }
    }
}
