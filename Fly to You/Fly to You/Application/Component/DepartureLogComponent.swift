//
//  DepartureLogComponent.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//


// MARK: - RootDependency

protocol DepartureLogDependency {
    var departureLogFactory: any DepartureLogFactory { get }
}

// MARK: - RootComponent

final class DepartureLogComponent {
    private let dependency: DepartureLogDependency

    init(dependency: DepartureLogDependency) {
        self.dependency = dependency
    }

    func makeDepartureLogView() -> some View {
        AnyView(dependency.landingZoneFactory.makeLandingZoneView())
    }
}
