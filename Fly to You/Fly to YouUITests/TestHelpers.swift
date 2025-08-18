//
//  TestHelpers.swift
//  Fly to YouUITests
//
//  Created by Claude on 8/18/25.
//

import XCTest

/// UI 테스트에서 사용하는 Launch Argument 정의
enum LaunchArgument: String, CaseIterable {
    case forceLogout = "-forceLogout"
    case skipSplash = "-skipSplash"
    case disableAnimations = "-disableAnimations"
    case uiTesting = "UITEST"
}

/// UI 테스트를 위한 XCUIApplication 확장
extension XCUIApplication {
    /// 지정된 launch arguments로 앱을 시작
    func launch(with arguments: [LaunchArgument]) {
        self.launchArguments = arguments.map { $0.rawValue }
        self.launch()
    }
    
    /// SignUp 테스트를 위한 앱 시작 (로그아웃 상태)
    static func launchForSignUpTest() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch(with: [.forceLogout, .uiTesting])
        return app
    }
    
    /// 일반 UI 테스트를 위한 앱 시작
    static func launchForUITest() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch(with: [.uiTesting])
        return app
    }
    
    /// 애니메이션 없는 테스트를 위한 앱 시작
    static func launchWithoutAnimations() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch(with: [.uiTesting, .disableAnimations])
        return app
    }
}
