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

    // MARK: - Repository
    
    func makeUserRepo() -> UserRepo {
        return DefaultUserRepo()
    }
    func makeLetterRepo() -> LetterRepo {
        return DefaultLetterRepo()
    }

    // MARK: - View Model
    
    func makeLandingZoneViewModel() -> LandingZoneViewModel {
        let useCase = makeFetchLettersUseCase()
        
        return DafultLandingZoneViewModel(fetchLetterUseCase: useCase)
    }

    // MARK: - View Model Wrapper

    func makeLandingZoneViewModelWrapper() -> LandingZoneViewModelWrapper {
        LandingZoneViewModelWrapper(viewModel: makeLandingZoneViewModel())
    }
}
