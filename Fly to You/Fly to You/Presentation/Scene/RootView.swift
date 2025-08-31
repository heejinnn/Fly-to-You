//
//  RootView.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import SwiftUI
import FirebaseAuth


struct RootView: View {
    @EnvironmentObject var appState: AppState
    @State private var sessionService = ProductionServiceFactory().createUserSessionService()

    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainTabView()
            } else {
                AppComponent()
                    .makeSignUpView()
            }
        }
        .onAppear {
            // UI 테스트에서 강제 로그아웃 설정이 있으면 로그아웃 상태로 시작
            if ProcessInfo.processInfo.shouldForceLogout{
                appState.isLoggedIn = false
            } else if Auth.auth().currentUser != nil, sessionService.isUserLoggedIn() {
                appState.isLoggedIn = true
            }
        }
    }
}
