//
//  AuthComponent.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import SwiftUI

// MARK: - RootDependency

protocol AuthDependency {
    var authFactory: any AuthFactory { get }
}

// MARK: - RootComponent

final class AuthComponent {
    private let dependency: AuthDependency

    init(dependency: AuthDependency) {
        self.dependency = dependency
    }

    func makeSignUpView() -> some View {
        AnyView(dependency.authFactory.makeSignUpView())
    }
}
