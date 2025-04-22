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
    
    func makeFetchFlightsUseCase() -> FetchFlightsUseCase {
        let userRepo = makeUserRepo()
        let flightRepo = makeFlightRepo()
        
        return DefaultFetchFlightsUseCase(userRepo: userRepo, flightRepo: flightRepo)
    }
   
 
    // MARK: - Repository
    
    func makeUserRepo() -> UserRepo {
        return DefaultUserRepo()
    }
    
    func makeFlightRepo() -> FlightRepo {
        return DefaultFlightRepo()
    }
    
    // MARK: - View Model
    
    func makeFlightMapViewModel() -> DefaultFlightMapViewModel{
        return DefaultFlightMapViewModel(useCase: makeFetchFlightsUseCase())
    }
    
    // MARK: - View Model Wrapper

    func makeFlightMapViewModelWrapper() -> FlightMapViewModelWrapper {
        FlightMapViewModelWrapper(viewModel: makeFlightMapViewModel())
    }
}
