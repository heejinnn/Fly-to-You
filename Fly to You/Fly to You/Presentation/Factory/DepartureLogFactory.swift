//
//  DepartureLogFactory.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//

import SwiftUI

// MARK: - DepartureLogDependency

struct DepartureLogFactoryDependency: DepartureLogDependency {
    let departureLogFactory: any DepartureLogFactory
}

// MARK: - MainFactory

protocol DepartureLogFactory {
    associatedtype SomeView: View
    func makeDepartureLogView() -> SomeView
}

// MARK: - DefaultMainFactory

final class DefaultDepartureLogFactory: DepartureLogFactory {
    private let depatureLogViewModelWrapper: DepatureLogViewModelWrapper
    
    init(depatureLogViewModelWrapper: DepatureLogViewModelWrapper) {
        self.depatureLogViewModelWrapper = depatureLogViewModelWrapper
    }
    
    public func makeDepartureLogView() -> some View { // some: "특정 타입만 반환"
        return DepartureLogView()
            .environmentObject(depatureLogViewModelWrapper)
    }
}
