//
//  ServiceFactory.swift
//  Fly to You
//
//  Created by 최희진 on 12/30/24.
//

import Foundation

protocol ServiceFactory {
    func createUserSessionService() -> UserSessionService
}
