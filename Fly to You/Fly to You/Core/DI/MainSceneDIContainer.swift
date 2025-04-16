//
//  MainSceneDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//



import SwiftUI

final class MainSceneDIContainer {
    // MARK: - Factory

    func makeMainFactory() -> DefaultMainFactory { // DefaultMainFactory를 생성하여 반환
        let viewModelWrapper = makeMainViewModelWrapper()
        return DefaultMainFactory(mainViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases
    
    private func makeSendLetterUseCase() -> SendLetterUseCase {
        let makeUserRepo = makeUserRepo()
        let makeLetterRepo = makeLetterRepo()
        let makeFlightrRepo = makeFlightrRepo()
        
        return DefaultSendLetterUseCase(userRepo: makeUserRepo, letterRepo: makeLetterRepo, flightRepo: makeFlightrRepo)
    }

    // MARK: - Repository
    
    func makeUserRepo() -> UserRepo {
        return DefaultUserRepo()
    }
    func makeLetterRepo() -> LetterRepo {
        return DefaultLetterRepo()
    }
    func makeFlightrRepo() -> FlightRepo {
        return DefaultFlightRepo()
    }

    // MARK: - View Model
    
    func makeSendLetterViewModel() -> SendLetterViewModel {
        let useCase = makeSendLetterUseCase()
        
        return DefaultSendLetterViewModel(sendLetterUseCase: useCase)
    }

    // MARK: - View Model Wrapper

    func makeMainViewModelWrapper() -> MainViewModelWrapper {
        MainViewModelWrapper(viewModel: makeSendLetterViewModel())
    }
}
