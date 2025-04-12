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

    // MARK: - Repository

    // MARK: - View Model

    // MARK: - View Model Wrapper

    func makeMainViewModelWrapper() -> MainViewModelWrapper {
        MainViewModelWrapper()
    }
}
