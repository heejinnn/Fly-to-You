//
//  RootView.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.isLoggedIn {
            MainTabView()
        } else {
            SignUpView(viewModelWrapper: AuthViewModelWrapper(viewModel: DefaultAuthViewModel(signUpUseCase: DefaultSignUpUseCase(repository: DefaultSignUpRepo()))))
        }
    }
}
