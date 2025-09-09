//
//  UpdateNicknameUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 12/30/24.
//

import Foundation

protocol UpdateNicknameUseCase {
    func updateNickname(nickname: String) async throws
}

enum UpdateNicknameError: LocalizedError {
    case duplicateNickname
    case invalidNickname
    case updateFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .duplicateNickname:
            return "이미 사용 중인 닉네임입니다"
        case .invalidNickname:
            return "유효하지 않은 닉네임입니다"
        case .updateFailed(let error):
            return "닉네임 업데이트 실패: \(error.localizedDescription)"
        }
    }
}

struct DefaultUpdateNicknameUseCase: UpdateNicknameUseCase {
    private let userRepo: UserRepo
    
    init(userRepo: UserRepo) {
        self.userRepo = userRepo
    }
    
    func updateNickname(nickname: String) async throws {
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)
        
        guard !trimmed.isEmpty else {
            throw UpdateNicknameError.invalidNickname
        }
        
        let isDuplicate = try await userRepo.checkNicknameDuplicate(nickname: trimmed)
        guard !isDuplicate else {
            throw UpdateNicknameError.duplicateNickname
        }
        
        do {
            try await userRepo.updateNickname(nickname: trimmed)
        } catch {
            throw UpdateNicknameError.updateFailed(error)
        }
    }
}
