//
//  MainSceneDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//



import SwiftUI

final class MainSceneDIContainer: BaseDIContainer {
    // MARK: - Factory

    func makeMainFactory() -> DefaultMainFactory { // DefaultMainFactory를 생성하여 반환
        let viewModelWrapper = makeMainViewModelWrapper()
        return DefaultMainFactory(mainViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases
    
    private func makeSendLetterUseCase() -> SendLetterUseCase {
        let userRepo = makeUserRepo()
        let letterRepo = makeLetterRepo()
        let flightRepo = makeFlightRepo()
        
        return DefaultSendLetterUseCase(userRepo: userRepo, letterRepo: letterRepo, flightRepo: flightRepo)
    }
    
    private func makeFetchLettersUseCase() -> FetchLettersUseCase {
        let userRepo = makeUserRepo()
        let letterRepo = makeLetterRepo()
        
        return DefaultFetchLettersUseCase(letterRepo: letterRepo, userRepo: userRepo)
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
    
    func makeSendLetterViewModel() -> SendLetterViewModel {
        let sendLetterUseCase = makeSendLetterUseCase()
        let fetchLettersUseCase = makeFetchLettersUseCase()
        
        return DefaultSendLetterViewModel(sendLetterUseCase: sendLetterUseCase, fetchLettersUseCase: fetchLettersUseCase)
    }

    // MARK: - View Model Wrapper

    func makeMainViewModelWrapper() -> MainViewModelWrapper {
        MainViewModelWrapper(viewModel: makeSendLetterViewModel())
    }
}
