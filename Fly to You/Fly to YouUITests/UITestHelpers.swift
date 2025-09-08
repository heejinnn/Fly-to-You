//
//  UITestHelpers.swift
//  Fly to YouUITests
//
//  Created by 최희진 on 8/18/25.
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
        static let tabView = "main.tabView"
        static let flightTab = "main.flightTab"
        static let mapTab = "main.mapTab"
        static let profileTab = "main.profileTab"
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
        static let userListButton = "sendLetter.userListButton"
    }
    
    struct FlyAnimation {
        static let completionText = "flyAnimation.completionText"
    }
    
    /// 공통 UI 요소 식별자
    struct Common {
        static let backButton = "common.backButton"
        static let closeButton = "common.closeButton"
        static let confirmButton = "common.confirmButton"
        static let cancelButton = "common.cancelButton"
        static let bottomButton = "common.bottomButton"
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
        app.launch(with: [.forceLogout, .skipSplash])
        return app
    }
    
    /// 일반 UI 테스트를 위한 앱 시작
    static func launchForUITest() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch(with: [.uiTesting, .skipSplash])
        return app
    }
    
    /// 애니메이션 없는 테스트를 위한 앱 시작
    static func launchWithoutAnimations() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch(with: [.uiTesting, .disableAnimations])
        return app
    }
}

// MARK: - UI Test Debugging Extensions
extension XCUIApplication {
    /// 현재 화면의 모든 UI 요소를 디버그 출력
    func debugPrintAllElements() {
        print("=== Debug: All UI Elements ===")
        let snapshot = self.debugDescription
        print(snapshot)
        print("=============================")
    }
    
    /// 특정 타입의 모든 요소를 디버그 출력
    func debugPrintElements(ofType type: XCUIElement.ElementType) {
        let elements = descendants(matching: type)
        print("=== Debug: \(type) Elements ===")
        for i in 0..<elements.count {
            let element = elements.element(boundBy: i)
            print("Element \(i): identifier='\(element.identifier)', label='\(element.label)', exists=\(element.exists)")
        }
        print("===============================")
    }
    
    /// 버튼 요소들을 디버그 출력
    func debugPrintButtons() {
        debugPrintElements(ofType: .button)
    }
}
