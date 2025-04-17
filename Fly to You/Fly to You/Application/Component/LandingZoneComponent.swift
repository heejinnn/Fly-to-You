//
//  LandingZoneComponent.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//



import SwiftUI

// MARK: - RootDependency

protocol LandingZoneDependency {
    var landingZoneFactory: any LandingZoneFactory { get }
}

// MARK: - RootComponent

final class LandingZoneComponent {
    private let dependency: LandingZoneDependency

    init(dependency: LandingZoneDependency) {
        self.dependency = dependency
    }

    func makeLandingZoneView() -> some View {
        AnyView(dependency.landingZoneFactory.makeLandingZoneView())
    }
}
