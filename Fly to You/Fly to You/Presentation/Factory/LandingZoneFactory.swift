//
//  LandingZoneFactory.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI

// MARK: - LandingZoneFactoryDependency

struct LandingZoneFactoryDependency: LandingZoneDependency {
    let landingZoneFactory: any LandingZoneFactory
}

// MARK: - LandingZoneFactory

protocol LandingZoneFactory {
    associatedtype SomeView: View
    func makeLandingZoneView() -> SomeView
}

// MARK: - DefaultLandingZoneFactory

final class DefaultLandingZoneFactory: LandingZoneFactory {
    private let landingZoneViewModelWrapper: LandingZoneViewModelWrapper

    init(landingZoneViewModelWrapper: LandingZoneViewModelWrapper) {
        self.landingZoneViewModelWrapper = landingZoneViewModelWrapper
    }

    public func makeLandingZoneView() -> some View { // some: "특정 타입만 반환"
        return LandingZoneView()
            .environmentObject(landingZoneViewModelWrapper)
    }
}
