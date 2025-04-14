//
//  NavigationRootView.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//

import SwiftUI

struct NavigationRootView: View {
    @StateObject var coordinator: AppCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.main)
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.build(route)
                }
        }
    }
}
