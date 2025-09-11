//
//  DepartureLogDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//

final class DepartureLogSceneDIContainer: BaseDIContainer {
    
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
    
    func makeEditLettersUseCase() -> EditLetterUseCase {
        let letterRepo = makeLetterRepo()
        let userRepo = makeUserRepo()
        let flightRepo = makeFlightRepo()
        
        return DefaultEditLetterUseCase(letterRepo: letterRepo, userRepo: userRepo, flightRepo: flightRepo)
    }
    
    func makeDeleteLettersUseCase() -> DeleteLetterUseCase {
        let letterRepo = makeLetterRepo()
        let flightRepo = makeFlightRepo()
        
        return DefaultDeleteLetterUseCase(letterRepo: letterRepo, flightRepo: flightRepo)
    }

    // MARK: - Repository
    
    func makeUserRepo() -> UserRepo {
        return DefaultUserRepo(sessionService: getUserSessionService())
    }
    
    func makeLetterRepo() -> LetterRepo {
        return DefaultLetterRepo(letterNetworkService: getLetterNetworkService())
    }
    
    func makeFlightRepo() -> FlightRepo {
        return DefaultFlightRepo(flightNetworkService: getFlightNetworkService())
    }


    // MARK: - View Model
    
    func makeDepartureLogViewModel() -> DepartureLogViewModel {
        return DefaultDepartureLogViewModel(fetchLetterUseCase: makeFetchLettersUseCase(), editLetterUseCase: makeEditLettersUseCase(), deleteLetterUseCase: makeDeleteLettersUseCase())
    }

    // MARK: - View Model Wrapper

    func makeDepatureLogViewModelWrapper() -> DepatureLogViewModelWrapper {
        DepatureLogViewModelWrapper(viewModel: makeDepartureLogViewModel())
    }
    
}
