//
//  BaseDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 12/30/24.
//

import Foundation

class BaseDIContainer {
    private let serviceFactory: ServiceFactory
    
    private lazy var _userSessionService: UserSessionService = serviceFactory.createUserSessionService()
    
    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }
    
    func getUserSessionService() -> UserSessionService {
        return _userSessionService
    }
}
