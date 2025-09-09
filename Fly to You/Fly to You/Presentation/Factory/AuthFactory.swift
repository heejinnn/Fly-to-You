//
//  AuthFactory.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import SwiftUI

// MARK: - AuthFactoryDependency

struct AuthFactoryDependency: AuthDependency {
    let authFactory: any AuthFactory
}

// MARK: - AuthFactory

protocol AuthFactory {
    associatedtype SomeView: View
    func makeSignUpView() -> SomeView
}

// MARK: - DefaultAuthFactory

final class DefaultAuthFactory: AuthFactory {
    private let authViewModelWrapper: AuthViewModelWrapper

    init(authViewModelWrapper: AuthViewModelWrapper) {
        self.authViewModelWrapper = authViewModelWrapper
    }

    public func makeSignUpView() -> some View { // some: "특정 타입만 반환"
        return SignUpView(viewModelWrapper: authViewModelWrapper)
    }
}
