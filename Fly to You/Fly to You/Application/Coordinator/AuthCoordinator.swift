//
//  AuthCoordinator.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import SwiftUI

// MARK: - AuthDependency

protocol AuthDependency {
    var authFactory: any AuthFactory { get }
}

// MARK: - AuthCoordinator

final class AuthCoordinator {
    private let dependency: AuthDependency

    init(dependency: AuthDependency) {
        self.dependency = dependency
    }

    func makeSignUpView() -> some View {
        AnyView(dependency.authFactory.makeSignUpView())
    }
}
