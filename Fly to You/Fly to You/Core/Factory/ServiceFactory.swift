//
//  ServiceFactory.swift
//  Fly to You
//
//  Created by Claude on 12/30/24.
//

import Foundation

protocol ServiceFactory {
    func createUserSessionService() -> UserSessionService
}