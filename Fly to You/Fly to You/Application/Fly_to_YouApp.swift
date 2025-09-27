//
//  Fly_to_YouApp.swift
//  Fly to You
//
//  Created by 최희진 on 4/12/25.
//

import SwiftUI

@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var showSplash = true
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            showSplash = false
                        })
                    }
            } else {
                RootView()
                    .environmentObject(appState)
            }
        }
    }
}
