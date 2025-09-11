//
//  BaseDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 12/30/24.
//

import Foundation

class BaseDIContainer {
    private let serviceFactory: ServiceFactory
    
    private lazy var userSessionService: UserSessionService = serviceFactory.createUserSessionService()
    private lazy var letterNetworkService: LetterNetworkService = serviceFactory.createLetterNetworkService()
    private lazy var flightNetworkService: FlightNetworkService = serviceFactory.createFlightNetworkService()
    private lazy var throttlerService: ThrottlerService = serviceFactory.createThrottlerService()
    
    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }
    
    func getUserSessionService() -> UserSessionService {
        return userSessionService
    }
    
    func getLetterNetworkService() -> LetterNetworkService {
        return letterNetworkService
    }
    
    func getFlightNetworkService() -> FlightNetworkService {
        return flightNetworkService
    }
    
    func getThrottlerService() -> ThrottlerService {
        return throttlerService
    }
}

