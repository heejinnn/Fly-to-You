//
//  AppComponent.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//


import SwiftUI

final class AppComponent {
    
    private let appDIContainer = AppDIContainer()

    func makeRootView() -> some View {
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer()
        let mainFactory = mainSceneDIContainer.makeMainFactory()
        return rootComponent(mainFactory: mainFactory).makeMainView()
    }
    
    func makeSignUpView() -> some View {
        let signUpSceneDIContainer = appDIContainer.makeSignUpSceneDIContainer()
        let signUpFactory = signUpSceneDIContainer.makeSignUpFactory()
        return authComponent(authFactory: signUpFactory).makeSignUpView()
    }

    private func rootComponent(mainFactory: any MainFactory) -> RootComponent {
        RootComponent(dependency: MainFactoryDependency(mainFactory: mainFactory))
    }
    
    private func authComponent(authFactory: any AuthFactory) -> AuthComponent {
        AuthComponent(dependency: AuthFactoryDependency(authFactory: authFactory))
    }
}
