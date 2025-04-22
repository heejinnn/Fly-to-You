//
//  FlightMapFactory.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import SwiftUI

// MARK: - FlightMapFactoryDependency

struct FlightMapFactoryDependency: FlightMapDependency {
    let flightMapFactory: any FlightMapFactory
}

// MARK: - FlightMapFactory

protocol FlightMapFactory {
    associatedtype SomeView: View
    func makeFlightMapView() -> SomeView
}

// MARK: - DefaultFlightMapFactory

final class DefaultFlightMapFactory: FlightMapFactory {
    private let flightMapViewModelWrapper: FlightMapViewModelWrapper

    init(flightMapViewModelWrapper: FlightMapViewModelWrapper) {
        self.flightMapViewModelWrapper = flightMapViewModelWrapper
    }

    public func makeFlightMapView() -> some View { // some: "특정 타입만 반환"
        return FlightMapView()
            .environmentObject(flightMapViewModelWrapper)
    }
}
