//
//  FlightMapCoordinator.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//


import SwiftUI

// MARK: - FlightMapDependency

protocol FlightMapDependency {
    var flightMapFactory: any FlightMapFactory { get }
}

// MARK: - FlightMapCoordinator

final class FlightMapCoordinator {
    private let dependency: FlightMapDependency

    init(dependency: FlightMapDependency) {
        self.dependency = dependency
    }

    func makeFlightMapView() -> some View {
        AnyView(dependency.flightMapFactory.makeFlightMapView())
    }
}
