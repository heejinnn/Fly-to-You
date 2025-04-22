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
            AppComponent()
                .makeRootView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            AppComponent()
                .makeLandingZoneView()
                .tabItem {
                    Label("비행기 착륙장", systemImage: "tray")
                }

            AppComponent()
                .makeDepartureLogView()
                .tabItem {
                    Label("보낸 기록", systemImage: "doc")
                }
            
            AppComponent()
                .makeFlightMapView()
                .tabItem{
                    Label("항로 맵", systemImage: "map")
                }
        }
        .background(.white)
    }
}
