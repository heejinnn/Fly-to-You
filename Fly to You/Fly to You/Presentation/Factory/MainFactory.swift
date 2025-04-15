//
//  MainFactory.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//


import SwiftUI

// MARK: - MainFactoryDependency

struct MainFactoryDependency: RootDependency {
    let mainFactory: any MainFactory
}

// MARK: - MainFactory

protocol MainFactory {
    associatedtype SomeView: View
    func makeMainView() -> SomeView
}

// MARK: - DefaultMainFactory

final class DefaultMainFactory: MainFactory {
    private let mainViewModelWrapper: MainViewModelWrapper

    init(mainViewModelWrapper: MainViewModelWrapper) {
        self.mainViewModelWrapper = mainViewModelWrapper
    }

    public func makeMainView() -> some View { // some: "특정 타입만 반환"
        return MainView()
            .environmentObject(mainViewModelWrapper)
    }
}
