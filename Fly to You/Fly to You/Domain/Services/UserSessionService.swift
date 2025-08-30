//
//  UserSessionService.swift
//  Fly to You
//
//  Created by Claude on 12/30/24.
//

import Foundation

protocol UserSessionService {
    func getCurrentUserId() throws -> String
    func getCurrentUserNickname() -> String?
    func isUserLoggedIn() -> Bool
    func saveUserSession(uid: String, nickname: String)
    func clearSession()
}

enum UserSessionError: LocalizedError {
    case notLoggedIn
    case sessionCorrupted
    
    var errorDescription: String? {
        switch self {
        case .notLoggedIn:
            return "로그인이 필요합니다"
        case .sessionCorrupted:
            return "세션 정보가 손상되었습니다"
        }
    }
}