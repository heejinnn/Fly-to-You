//
//  AppCoordinator.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//


import SwiftUI

final class AppCoordinator {
    
    private let appDIContainer = AppDIContainer(serviceFactory: ProductionServiceFactory())

    func makeRootView() -> some View {
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer()
        let mainFactory = mainSceneDIContainer.makeMainFactory()
        return rootCoordinator(mainFactory: mainFactory).makeMainView()
    }
    
    func makeSignUpView() -> some View {
        let signUpSceneDIContainer = appDIContainer.makeSignUpSceneDIContainer()
        let signUpFactory = signUpSceneDIContainer.makeSignUpFactory()
        return authCoordinator(authFactory: signUpFactory).makeSignUpView()
    }
    
    func makeLandingZoneView() -> some View {
        let landingZoneSceneDIContainer = appDIContainer.makeLandingZoneSceneDIContainer()
        let landingZoneFactory = landingZoneSceneDIContainer.makeLandingZoneFactory()
        return landingZoneCoordinator(landingZoneFactory: landingZoneFactory).makeLandingZoneView()
    }
    
    func makeDepartureLogView() -> some View {
        let departureLogSceneDIContainer = appDIContainer.makeDepartureSceneDIContainer()
        let departureLogFactory = departureLogSceneDIContainer.makeDepartureLogFactory()
        return departureLogCoordinator(departureLogFactory: departureLogFactory).makeDepartureLogView()
    }
    
    func makeFlightMapView() -> some View {
        let flightMapSceneDIContainer = appDIContainer.makeFlightMapSceneDIContainer()
        let flightMapFactory = flightMapSceneDIContainer.makeFlightMapFactory()
        return flightMapCoordinator(flightMapFactory: flightMapFactory).makeFlightMapView()
    }
    
    private func rootCoordinator(mainFactory: any MainFactory) -> RootCoordinator {
        RootCoordinator(dependency: MainFactoryDependency(mainFactory: mainFactory))
    }
    
    private func authCoordinator(authFactory: any AuthFactory) -> AuthCoordinator {
        AuthCoordinator(dependency: AuthFactoryDependency(authFactory: authFactory))
    }
    
    private func landingZoneCoordinator(landingZoneFactory: any LandingZoneFactory) -> LandingZoneCoordinator {
        LandingZoneCoordinator(dependency: LandingZoneFactoryDependency(landingZoneFactory: landingZoneFactory))
    }
    
    private func departureLogCoordinator(departureLogFactory: any DepartureLogFactory) -> DepartureLogCoordinator{
        DepartureLogCoordinator(dependency: DepartureLogFactoryDependency(departureLogFactory: departureLogFactory))
    }
    
    private func flightMapCoordinator(flightMapFactory: any FlightMapFactory) -> FlightMapCoordinator{
        FlightMapCoordinator(dependency: FlightMapFactoryDependency(flightMapFactory: flightMapFactory))
    }
}
