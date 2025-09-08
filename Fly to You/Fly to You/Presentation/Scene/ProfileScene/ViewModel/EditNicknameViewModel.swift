//
//  EditNicknameViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 7/10/25.
//

import Foundation

final class EditNicknameViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var duplicateError: Bool = false
    
    private let updateNicknameUseCase: UpdateNicknameUseCase
    
    init(updateNicknameUseCase: UpdateNicknameUseCase) {
        self.updateNicknameUseCase = updateNicknameUseCase
    }

    func updateNickname(completion: @escaping (Bool) -> Void) {
        Task {
            do {
                try await updateNicknameUseCase.updateNickname(nickname: nickname)
                
                await MainActor.run {
                    self.duplicateError = false
                    completion(true)
                }
            } catch UpdateNicknameError.duplicateNickname {
                await MainActor.run {
                    self.duplicateError = true
                    completion(false)
                }
            } catch {
                Log.error("닉네임 업데이트 실패: \(error)")
                await MainActor.run {
                    completion(false)
                }
            }
        }
    }
}
