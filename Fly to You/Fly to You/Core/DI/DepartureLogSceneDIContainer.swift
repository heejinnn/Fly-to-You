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

    // MARK: - Repository

    // MARK: - View Model

    // MARK: - View Model Wrapper

    func makeDepatureLogViewModelWrapper() -> DepatureLogViewModelWrapper {
        DepatureLogViewModelWrapper()
    }
    
}
