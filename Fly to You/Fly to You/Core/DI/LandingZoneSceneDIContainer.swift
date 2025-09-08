//
//  LandingZoneSceneDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//


final class LandingZoneSceneDIContainer: BaseDIContainer {
    // MARK: - Factory

    func makeLandingZoneFactory() -> DefaultLandingZoneFactory {
        let viewModelWrapper = makeLandingZoneViewModelWrapper()
        return DefaultLandingZoneFactory(landingZoneViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases
    
    private func makeFetchLettersUseCase() -> FetchLettersUseCase {
        let userRepo = makeUserRepo()
        let letterRepo = makeLetterRepo()
        
        return DefaultFetchLettersUseCase(letterRepo: letterRepo, userRepo: userRepo)
    }
    
    private func makeRelayLetterUseCase() -> RelayLetterUseCase {
        let userRepo = makeUserRepo()
        let flightRepo = makeFlightRepo()
        let letterRepo = makeLetterRepo()
        
        return DefaultRelayLetterUseCase(userRepo: userRepo, flightRepo: flightRepo, letterRepo: letterRepo)
    }
    
    private func makeBlockLetterUseCase() -> BlockLetterUseCase {
        let letterRepo = makeLetterRepo()
        
        return DefaultBlockLetterUseCase(letterRepo: letterRepo)
    }
   

    // MARK: - Repository
    
    func makeUserRepo() -> UserRepo {
        return DefaultUserRepo(sessionService: getUserSessionService())
    }
    
    func makeLetterRepo() -> LetterRepo {
        return DefaultLetterRepo(sessionService: getUserSessionService())
    }
    
    func makeFlightRepo() -> FlightRepo {
        return DefaultFlightRepo()
    }

    // MARK: - View Model
    
    func makeLandingZoneViewModel() -> LandingZoneViewModel {
        let useCase = makeFetchLettersUseCase()
        let relayLetterUseCase = makeRelayLetterUseCase()
        let blockLetterUseCase = makeBlockLetterUseCase()
        
        return DafultLandingZoneViewModel(fetchLetterUseCase: useCase, relayLetterUseCase: relayLetterUseCase, blockLetterUseCase: blockLetterUseCase)
    }

    // MARK: - View Model Wrapper

    func makeLandingZoneViewModelWrapper() -> LandingZoneViewModelWrapper {
        LandingZoneViewModelWrapper(viewModel: makeLandingZoneViewModel())
    }
}
