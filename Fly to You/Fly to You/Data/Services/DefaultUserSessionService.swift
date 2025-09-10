//
//  DefaultUserSessionService.swift
//  Fly to You
//
//  Created by 최희진 on 12/30/24.
//

import Foundation

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

final class DefaultUserSessionService: UserSessionService {
    private let storage: SessionStorage
    
    private enum Keys {
        static let uid = "uid"
        static let nickname = "nickname"
    }
    
    init(storage: SessionStorage) {
        self.storage = storage
    }
    
    func getCurrentUserId() throws -> String {
        guard let uid = storage.load(key: Keys.uid),
              !uid.isEmpty else {
            throw UserSessionError.notLoggedIn
        }
        return uid
    }
    
    func getCurrentUserNickname() -> String? {
        return storage.load(key: Keys.nickname)
    }
    
    func isUserLoggedIn() -> Bool {
        return (try? getCurrentUserId()) != nil
    }
    
    func saveUserSession(uid: String, nickname: String) {
        storage.save(key: Keys.uid, value: uid)
        storage.save(key: Keys.nickname, value: nickname)
    }
    
    func clearSession() {
        storage.clear()
    }
}
