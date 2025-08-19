//
//  UITestHelpers.swift
//  Fly to YouUITests
//
//  Created by Claude on 8/18/25.
//

import XCTest

/// UI 테스트에서 사용하는 AccessibilityIdentifier 상수 정의
struct TestAccessibilityIdentifiers {
    struct SignUp {
        static let nicknameTextField = "signUp.nicknameTextField"
        static let eulaCheckbox = "signUp.eulaCheckbox"
        static let eulaDetailButton = "signUp.eulaDetailButton"
        static let completeButton = "signUp.completeButton"
        static let duplicateErrorText = "signUp.duplicateErrorText"
        static let eulaSheet = "signUp.eulaSheet"
    }
    
    struct Main {
        static let flyButton = "main.flyButton"
    }
    
    struct SelectSubject {
        static let nextButton = "selectSubject.nextButton"
        static let customTopicTextField = "selectSubject.customTopicTextField"
        static let topicButton = "selectSubject.topicButton"
    }
    
    struct SendLetter {
        static let flyButton = "sendLetter.flyButton"
        static let toUserButton = "sendLetter.toUserButton"
        static let messageTextEditor = "sendLetter.messageTextEditor"
        static let userListSheet = "sendLetter.userListSheet"
    }
    
    struct FlyAnimation {
        static let homeButton = "flyAnimation.homeButton"
        static let completionText = "flyAnimation.completionText"
    }
}

/// UI 테스트에서 사용하는 Launch Argument 정의
enum LaunchArgument: String, CaseIterable {
    case forceLogout = "-forceLogout"
    case skipSplash = "-skipSplash"
    case disableAnimations = "-disableAnimations"
    case uiTesting = "-uiTest"
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
        app.launch(with: [.forceLogout, .uiTesting, .skipSplash])
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
