//
//  DepartureLogDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//

final class DepartureLogSceneDIContainer{
    
    func makeDepartureLogFactory() -> DefaultDepartureLogFactory {
        let viewModelWrapper = makeDepatureLogViewModelWrapper()
        return DefaultDepartureLogFactory(depatureLogViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases
    
    func makeFetchLettersUseCase() -> FetchLettersUseCase {
        let letterRepo = makeLetterRepo()
        let userRepo = makeUserRepo()
        
        return DefaultFetchLettersUseCase(letterRepo: letterRepo, userRepo: userRepo)
    }

    // MARK: - Repository
    
    func makeUserRepo() -> UserRepo {
        return DefaultUserRepo()
    }
    
    func makeLetterRepo() -> LetterRepo {
        return DefaultLetterRepo()
    }


    // MARK: - View Model
    
    func makeDepartureLogViewModel() -> DepartureLogViewModel {
        return DefaultDepartureLogViewModel(useCase: makeFetchLettersUseCase())
    }

    // MARK: - View Model Wrapper

    func makeDepatureLogViewModelWrapper() -> DepatureLogViewModelWrapper {
        DepatureLogViewModelWrapper(viewModel: makeDepartureLogViewModel())
    }
    
}
