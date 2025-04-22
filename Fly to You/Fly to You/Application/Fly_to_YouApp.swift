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
    @State private var gifReady = false
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView(gifReady: $gifReady)
                    .onChange(of: gifReady) { ready in
                        if ready {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showSplash = false
                                }
                            }
                        }
                    }
            } else {
                RootView()
                    .environmentObject(appState)
            }
        }
    }
}
