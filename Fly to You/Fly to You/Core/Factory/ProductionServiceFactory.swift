//
//  ProductionServiceFactory.swift
//  Fly to You
//
//  Created by 최희진 on 12/30/24.
//

import Foundation

final class ProductionServiceFactory: ServiceFactory {
    func createUserSessionService() -> UserSessionService {
        let storage = UserDefaultsSessionStorage()
        return DefaultUserSessionService(storage: storage)
    }
}
