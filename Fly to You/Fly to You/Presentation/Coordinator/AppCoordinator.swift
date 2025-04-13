//
//  AppCoordinator.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    
    private let mainViewModelWrapper: MainViewModelWrapper
    
    init(mainViewModelWrapper: MainViewModelWrapper) {
        self.mainViewModelWrapper = mainViewModelWrapper
    }
    
    @ViewBuilder
    func build(_ route: AppRoute) -> some View {
        switch route {
        case .main:
            MainView(viewModelWrapper: mainViewModelWrapper)
        case .splash:
            SplashView(gifReady: .constant(false))
        }
    }
}
