//
//  AppDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//


import Foundation

final class AppDIContainer {
    private let serviceFactory: ServiceFactory
    
    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }

    // MARK: - DIContainers of scenes

    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        return MainSceneDIContainer(serviceFactory: serviceFactory)
    }
    
    func makeSignUpSceneDIContainer() -> AuthSceneDIContainer {
        return AuthSceneDIContainer(serviceFactory: serviceFactory)
    }
    
    func makeLandingZoneSceneDIContainer() -> LandingZoneSceneDIContainer {
        return LandingZoneSceneDIContainer(serviceFactory: serviceFactory)
    }
    
    func makeDepartureSceneDIContainer() -> DepartureLogSceneDIContainer {
        return DepartureLogSceneDIContainer(serviceFactory: serviceFactory)
    }
    
    func makeFlightMapSceneDIContainer() -> FlightMapSceneDIContainer {
        return FlightMapSceneDIContainer(serviceFactory: serviceFactory)
    }
}
