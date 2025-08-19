//
//  ProcessInfo+Testing.swift
//  Fly to You
//
//  Created by Claude on 8/18/25.
//

import Foundation

extension ProcessInfo {
    /// UI 테스트 실행 여부 확인
    var isUITesting: Bool {
        return arguments.contains("-uiTest")
    }
    
    /// 강제 로그아웃 상태로 시작할지 여부
    var shouldForceLogout: Bool {
        return arguments.contains("-forceLogout")
    }
    
    /// 스플래시 화면을 건너뛸지 여부
    var shouldSkipSplash: Bool {
        return arguments.contains("-skipSplash")
    }
    
    /// 애니메이션을 비활성화할지 여부
    var shouldDisableAnimations: Bool {
        return isUITesting || arguments.contains("-disableAnimations")
    }
}
