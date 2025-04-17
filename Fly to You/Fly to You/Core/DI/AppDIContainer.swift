//
//  AppDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//


import Foundation

final class AppDIContainer {

    // MARK: - DIContainers of scenes

    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        return MainSceneDIContainer()
    }
    
    func makeSignUpSceneDIContainer() -> AuthSceneDIContainer {
        return AuthSceneDIContainer()
    }
    
    func makeLandingZoneSceneDIContainer() -> LandingZoneSceneDIContainer {
        return LandingZoneSceneDIContainer()
    }
}
