//
//  FlightMapSceneDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//


final class FlightMapSceneDIContainer: BaseDIContainer {
    // MARK: - Factory

    func makeFlightMapFactory() -> DefaultFlightMapFactory {
        let viewModelWrapper = makeFlightMapViewModelWrapper()
        return DefaultFlightMapFactory(flightMapViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases
    
    func makeFetchFlightsUseCase() -> FetchFlightsUseCase {
        let userRepo = makeUserRepo()
        let letterRepo = makeLetterRepo()
        let flightRepo = makeFlightRepo()
        
        return DefaultFetchFlightsUseCase(userRepo: userRepo, letterRepo: letterRepo, flightRepo: flightRepo)
    }
    
    func makeBlockLetterUseCase() -> BlockLetterUseCase {
        let letterRepo = makeLetterRepo()
        
        return DefaultBlockLetterUseCase(letterRepo: letterRepo)
    }
    
    func makeGetParticipationCountUseCase() -> GetParticipationCountUseCase {
        return DefaultGetParticipationCountUseCase()
    }
 
    // MARK: - Repository
    
    func makeUserRepo() -> UserRepo {
        return DefaultUserRepo()
    }
    
    func makeLetterRepo() -> LetterRepo {
        return DefaultLetterRepo(sessionService: getUserSessionService())
    }
    
    func makeFlightRepo() -> FlightRepo {
        return DefaultFlightRepo()
    }
    
    // MARK: - View Model
    
    func makeFlightMapViewModel() -> DefaultFlightMapViewModel{
        return DefaultFlightMapViewModel(
            fetchFlightsUseCase: makeFetchFlightsUseCase(), 
            blockLetterUseCase: makeBlockLetterUseCase(),
            getParticipationCountUseCase: makeGetParticipationCountUseCase()
        )
    }
    
    // MARK: - View Model Wrapper

    func makeFlightMapViewModelWrapper() -> FlightMapViewModelWrapper {
        FlightMapViewModelWrapper(viewModel: makeFlightMapViewModel())
    }
}
