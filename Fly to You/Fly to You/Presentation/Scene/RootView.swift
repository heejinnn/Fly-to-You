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
            if Auth.auth().currentUser != nil, ((UserDefaults.standard.string(forKey: "uid")?.isEmpty) != nil) {
                appState.isLoggedIn = true
                print(Auth.auth().currentUser?.uid)
            }
        }
    }
}
