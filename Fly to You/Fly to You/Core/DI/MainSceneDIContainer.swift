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
        let repository = makeSendLetterRepo()
        return DefaultSendLetterUseCase(repository: repository)
    }

    // MARK: - Repository
    
    func makeSendLetterRepo() -> SendLetterRepo {
        return DefaultSendLetterRepo()
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
