//
//  RootComponent.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//

import SwiftUI

// MARK: - RootDependency

protocol RootDependency {
    var mainFactory: any MainFactory { get }
}

// MARK: - RootComponent

final class RootComponent {
    private let dependency: RootDependency

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    func makeMainView() -> some View {
        AnyView(dependency.mainFactory.makeMainView())
    }
}
