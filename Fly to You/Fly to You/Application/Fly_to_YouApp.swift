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
                    .onChange(of: gifReady, { oldValue, newValue in
                        if newValue {
                            if ProcessInfo.processInfo.shouldSkipSplash{
                                showSplash = false
                            } else{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showSplash = false
                                    }
                                }
                            }
                        }
                    })
            } else {
                RootView()
                    .environmentObject(appState)
            }
        }
    }
}
