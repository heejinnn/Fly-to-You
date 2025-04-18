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
        let userRepo = makeUserRepo()
        let letterRepo = makeLetterRepo()
        let flightRepo = makeFlightRepo()
        
        return DefaultSendLetterUseCase(userRepo: userRepo, letterRepo: letterRepo, flightRepo: flightRepo)
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
    
    func makeSendLetterViewModel() -> SendLetterViewModel {
        let sendLetterUseCase = makeSendLetterUseCase()
        
        return DefaultSendLetterViewModel(sendLetterUseCase: sendLetterUseCase)
    }

    // MARK: - View Model Wrapper

    func makeMainViewModelWrapper() -> MainViewModelWrapper {
        MainViewModelWrapper(viewModel: makeSendLetterViewModel())
    }
}
