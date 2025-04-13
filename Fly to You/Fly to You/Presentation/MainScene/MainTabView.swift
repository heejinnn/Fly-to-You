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

            LandingZoneView()
                .tabItem {
                    Label("비행기 착륙장", systemImage: "tray")
                }

            DepartureLogView()
                .tabItem {
                    Label("보낸 기록", systemImage: "doc")
                }
            
            FlightMapView()
                .tabItem{
                    Label("항로 맵", systemImage: "map")
                }
        }
        .background(.white)
    }
}



struct LandingZoneView: View {
    var body: some View {
        NavigationStack {
            Text("비행기 착륙장 화면")
                .navigationTitle("비행기 착륙장")
        }
    }
}

struct DepartureLogView: View {
    var body: some View {
        NavigationStack {
            Text("보낸 기록 화면")
                .navigationTitle("보낸 기록")
        }
    }
}

struct FlightMapView: View{
    var body: some View{
        NavigationStack {
            Text("항공 맵 화면")
                .navigationTitle("항공 맵")
        }
    }
}
