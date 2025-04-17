//
//  LandingZoneFactory.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI

// MARK: - MainFactoryDependency

struct LandingZoneFactoryDependency: RootDependency {
    let landingZoneFactory: any LandingZoneFactory
}

// MARK: - MainFactory

protocol LandingZoneFactory {
    associatedtype SomeView: View
    func makeMainView() -> SomeView
}

// MARK: - DefaultMainFactory

final class DefaultLandingZoneFactory: LandingZoneFactory {
    private let landingZoneViewModelWrapper: LandingZoneViewModelWrapper

    init(landingZoneViewModelWrapper: LandingZoneViewModelWrapper) {
        self.landingZoneViewModelWrapper = landingZoneViewModelWrapper
    }

    public func makeMainView() -> some View { // some: "특정 타입만 반환"
        return LandingZoneView()
            .environmentObject(landingZoneViewModelWrapper)
    }
}
