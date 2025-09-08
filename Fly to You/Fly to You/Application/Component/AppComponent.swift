//
//  AppComponent.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//


import SwiftUI

final class AppComponent {
    
    private let appDIContainer = AppDIContainer(serviceFactory: ProductionServiceFactory())

    func makeRootView() -> some View {
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer()
        let mainFactory = mainSceneDIContainer.makeMainFactory()
        return rootComponent(mainFactory: mainFactory).makeMainView()
    }
    
    func makeSignUpView() -> some View {
        let signUpSceneDIContainer = appDIContainer.makeSignUpSceneDIContainer()
        let signUpFactory = signUpSceneDIContainer.makeSignUpFactory()
        return authComponent(authFactory: signUpFactory).makeSignUpView()
    }
    
    func makeLandingZoneView() -> some View {
        let landingZoneSceneDIContainer = appDIContainer.makeLandingZoneSceneDIContainer()
        let landingZoneFactory = landingZoneSceneDIContainer.makeLandingZoneFactory()
        return randingZoneComponent(landingZoneFactory: landingZoneFactory).makeLandingZoneView()
    }
    
    func makeDepartureLogView() -> some View {
        let departureLogSceneDIContainer = appDIContainer.makeDepartureSceneDIContainer()
        let departureLogFactory = departureLogSceneDIContainer.makeDepartureLogFactory()
        return departureLogComponent(departureLogFactory: departureLogFactory).makeDepartureLogView()
    }
    
    func makeFlightMapView() -> some View {
        let flightMapSceneDIContainer = appDIContainer.makeFlightMapSceneDIContainer()
        let flightMapFactory = flightMapSceneDIContainer.makeFlightMapFactory()
        return flightMapComponent(flightMapFactory: flightMapFactory).makeFlightMapView()
    }
    
    private func rootComponent(mainFactory: any MainFactory) -> RootComponent {
        RootComponent(dependency: MainFactoryDependency(mainFactory: mainFactory))
    }
    
    private func authComponent(authFactory: any AuthFactory) -> AuthComponent {
        AuthComponent(dependency: AuthFactoryDependency(authFactory: authFactory))
    }
    
    private func randingZoneComponent(landingZoneFactory: any LandingZoneFactory) -> LandingZoneComponent {
        LandingZoneComponent(dependency: LandingZoneFactoryDependency(landingZoneFactory: landingZoneFactory))
    }
    
    private func departureLogComponent(departureLogFactory: any DepartureLogFactory) -> DepartureLogComponent{
        DepartureLogComponent(dependency: DepartureLogFactoryDependency(departureLogFactory: departureLogFactory))
    }
    
    private func flightMapComponent(flightMapFactory: any FlightMapFactory) -> FlightMapComponent{
        FlightMapComponent(dependency: FlightMapFactoryDependency(flightMapFactory: flightMapFactory))
    }
}
