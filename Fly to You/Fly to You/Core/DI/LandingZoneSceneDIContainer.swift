//
//  LandingZoneSceneDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//


final class LandingZoneSceneDIContainer {
    // MARK: - Factory

    func makeLandingZoneFactory() -> DefaultLandingZoneFactory {
        let viewModelWrapper = makeLandingZoneViewModelWrapper()
        return DefaultLandingZoneFactory(landingZoneViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases
    
    private func makeFetchLettersUseCase() -> FetchLettersUseCase {
        let makeUserRepo = makeUserRepo()
        let makeLetterRepo = makeLetterRepo()
        
        return DefaultFetchLettersUseCase(letterRepo: makeLetterRepo, userRepo: makeUserRepo)
    }
    
    private func makeRelayLetterUseCase() -> RelayLetterUseCase {
        let userRepo = makeUserRepo()
        let flightRepo = makeFlightRepo()
        
        return DefaultRelayLetterUseCase(userRepo: userRepo, flightRepo: flightRepo)
    }

    // MARK: - Repository
    
    func makeUserRepo() -> UserRepo {
        return DefaultUserRepo()
    }
    
    func makeLetterRepo() -> LetterRepo {
        return DefaultLetterRepo()
    }
    
    func makeFlightRepo() -> FlightRepo {
        return DefaultFlightRepo()
    }

    // MARK: - View Model
    
    func makeLandingZoneViewModel() -> LandingZoneViewModel {
        let useCase = makeFetchLettersUseCase()
        let relayLetterUseCase = makeRelayLetterUseCase()
        
        return DafultLandingZoneViewModel(fetchLetterUseCase: useCase, relayLetterUseCase: relayLetterUseCase)
    }

    // MARK: - View Model Wrapper

    func makeLandingZoneViewModelWrapper() -> LandingZoneViewModelWrapper {
        LandingZoneViewModelWrapper(viewModel: makeLandingZoneViewModel())
    }
}
