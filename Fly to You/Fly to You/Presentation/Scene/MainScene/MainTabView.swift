//
//  MainTabView.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            AppCoordinator()
                .makeRootView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            AppCoordinator()
                .makeLandingZoneView()
                .tabItem {
                    Label("비행기 착륙장", systemImage: "tray")
                }

            AppCoordinator()
                .makeDepartureLogView()
                .tabItem {
                    Label("보낸 기록", systemImage: "doc")
                }
            
            AppCoordinator()
                .makeFlightMapView()
                .tabItem{
                    Label("항로 맵", systemImage: "map")
                }
        }
        .background(.white)
    }
}
