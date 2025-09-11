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
    
    func createThrottlerService() -> ThrottlerService {
        return ThrottlerService()
    }
    
    func createLetterNetworkService() -> LetterNetworkService {
        return FirebaseLetterNetworkService(
            sessionService: createUserSessionService(), throttlerService: createThrottlerService()
        )
    }
    
    func createFlightNetworkService() -> FlightNetworkService {
        return FirebaseFlightNetworkService(throttlerService: createThrottlerService())
    }
}
