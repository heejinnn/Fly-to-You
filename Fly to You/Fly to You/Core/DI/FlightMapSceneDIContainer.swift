//
//  FlightMapSceneDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//


final class FlightMapSceneDIContainer {
    // MARK: - Factory

    func makeFlightMapFactory() -> DefaultFlightMapFactory {
        let viewModelWrapper = makeFlightMapViewModelWrapper()
        return DefaultFlightMapFactory(flightMapViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases
    
 
    // MARK: - Repository
    
    // MARK: - View Model
    
    // MARK: - View Model Wrapper

    func makeFlightMapViewModelWrapper() -> FlightMapViewModelWrapper {
        FlightMapViewModelWrapper()
    }
}
