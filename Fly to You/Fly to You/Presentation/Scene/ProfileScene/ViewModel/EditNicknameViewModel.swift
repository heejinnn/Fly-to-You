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

    func updateNickname(completion: @escaping (Bool) -> Void) {
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        checkNicknameDuplicate(nickname: trimmed) { [weak self] isDuplicate in
            guard let self = self else { return }

            if isDuplicate {
                self.duplicateError = true
                return
            }

            guard let uid = UserDefaults.standard.string(forKey: "uid") else { return }

            db.collection("users").document(uid).updateData([
                "nickname": trimmed
            ]) { error in
                if let error = error {
                    Log.error("닉네임 업데이트 실패: \(error)")
                    return
                }

                UserDefaults.standard.set(trimmed, forKey: "nickname")
                self.duplicateError = false
                completion(true)
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
