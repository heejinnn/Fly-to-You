//
//  UserSessionService.swift
//  Fly to You
//
//  Created by 최희진 on 12/30/24.
//

import Foundation

protocol UserSessionService {
    func getCurrentUserId() throws -> String
    func getCurrentUserNickname() -> String?
    func isUserLoggedIn() -> Bool
    func saveUserSession(uid: String, nickname: String)
    func clearSession()
}
