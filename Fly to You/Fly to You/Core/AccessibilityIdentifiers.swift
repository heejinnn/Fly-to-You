//
//  AccessibilityIdentifiers.swift
//  Fly to You
//
//  Created by Claude on 8/18/25.
//

import Foundation

/// 앱 전체에서 사용하는 Accessibility Identifier 상수 정의
struct AccessibilityIdentifiers {
    
    /// SignUpView 관련 식별자
    struct SignUp {
        static let nicknameTextField = "signUp.nicknameTextField"
        static let eulaCheckbox = "signUp.eulaCheckbox"
        static let eulaDetailButton = "signUp.eulaDetailButton"
        static let completeButton = "signUp.completeButton"
        static let duplicateErrorText = "signUp.duplicateErrorText"
        static let eulaSheet = "signUp.eulaSheet"
    }
    
    /// MainView 관련 식별자
    struct Main {
        static let tabView = "main.tabView"
        static let flightTab = "main.flightTab"
        static let mapTab = "main.mapTab"
        static let profileTab = "main.profileTab"
    }
    
    /// 공통 UI 요소 식별자
    struct Common {
        static let backButton = "common.backButton"
        static let closeButton = "common.closeButton"
        static let confirmButton = "common.confirmButton"
        static let cancelButton = "common.cancelButton"
    }
}