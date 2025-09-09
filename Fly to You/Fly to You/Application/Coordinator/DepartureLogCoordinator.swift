//
//  DepartureLogCoordinator.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//

import SwiftUI


// MARK: - DepartureLogDependency

protocol DepartureLogDependency {
    var departureLogFactory: any DepartureLogFactory { get }
}

// MARK: - DepartureLogCoordinator

final class DepartureLogCoordinator {
    private let dependency: DepartureLogDependency

    init(dependency: DepartureLogDependency) {
        self.dependency = dependency
    }

    func makeDepartureLogView() -> some View {
        AnyView(dependency.departureLogFactory.makeDepartureLogView())
    }
}
