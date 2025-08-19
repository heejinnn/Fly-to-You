//
//  MainToFlyAnimationUITest.swift
//  Fly to YouUITests
//
//  Created by Claude on 8/19/25.
//

import XCTest

final class MainToFlyAnimationUITest: XCTestCase {
    
    var app: XCUIApplication!
    
    // MARK: - Helper Methods
    
    /// identifier 또는 텍스트로 버튼 찾기
    private func findButton(identifier: String) -> XCUIElement {
        return app.buttons[identifier]
    }
    
    /// 다음 버튼 찾기 (toolbar의 "다음" 버튼)
    private func findNextButton() -> XCUIElement {
        let nextById = app.buttons[TestAccessibilityIdentifiers.SelectSubject.nextButton]
        return nextById.exists ? nextById : app.buttons["다음"]
    }
    
    /// 날리기 버튼 찾기 (toolbar의 날리기 버튼)
    private func findFlyButton() -> XCUIElement {
        let flyById = app.buttons[TestAccessibilityIdentifiers.SendLetter.flyButton]
        return flyById.exists ? flyById : app.staticTexts["날리기"].firstMatch
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication.launchForUITest()
        
        // 앱이 MainView까지 로드될 때까지 대기
        sleep(3) // MainView가 완전히 로드될 때까지 대기
        
        // 디버깅: 현재 화면의 모든 버튼을 출력
        app.debugPrintButtons()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    /// MainView에서 FlyAnimationView까지의 전체 네비게이션 플로우 테스트
    func testCompleteNavigationFromMainToFlyAnimation() throws {
        // 1. MainView에서 "비행기 날리기" 버튼 탭
        let mainFlyButton = findButton(identifier: TestAccessibilityIdentifiers.Common.bottomButton)
        XCTAssertTrue(mainFlyButton.exists, "MainView의 비행기 날리기 버튼이 존재하지 않음")
        mainFlyButton.tap()
        
        // 2. SelectSubjectView로 이동 확인 및 주제 선택
        let nextButton = findNextButton()
        XCTAssertTrue(nextButton.waitForExistence(timeout: 5), "SelectSubjectView의 다음 버튼이 나타나지 않음")
        
        // 첫 번째 주제("응원 한마디") 선택 - 먼저 텍스트로 찾기 시도
        let firstTopicButton = app.buttons[TestAccessibilityIdentifiers.SelectSubject.topicButton].firstMatch
        XCTAssertTrue(firstTopicButton.waitForExistence(timeout: 3), "첫 번째 주제 버튼이 나타나지 않음")
        firstTopicButton.tap()
        
        // "다음" 버튼이 활성화되었는지 확인 후 탭
        XCTAssertTrue(nextButton.isEnabled, "주제 선택 후 다음 버튼이 활성화되지 않음")
        nextButton.tap()
        
        // 3. SendLetterView로 이동 확인 및 필수 정보 입력
        let toUserButton = app.buttons[TestAccessibilityIdentifiers.SendLetter.toUserButton]
        XCTAssertTrue(toUserButton.waitForExistence(timeout: 5), "SendLetterView의 받는 사람 버튼이 나타나지 않음")
        
        // 받는 사람 선택 (UserListSheet 열기)
        toUserButton.tap()
        
        // 시트가 열렸는지 확인
        let firstUserButton = app.buttons[TestAccessibilityIdentifiers.SendLetter.userListButton].firstMatch
        XCTAssertTrue(firstUserButton.waitForExistence(timeout: 5), "사용자 목록 시트의 첫 번째 사용자 버튼이 나타나지 않음")
        
        // 사용자 선택
        firstUserButton.tap()
        
        let startCoordinate =  app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.4))
        let endCoordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        startCoordinate.press(forDuration: 0.2, thenDragTo: endCoordinate)
        
        XCTAssertTrue(firstUserButton.waitForNonExistence(timeout: 3), "스와이프로 시트가 닫히지 않음")
        
        // 메시지 입력
        let messageTextEditor = app.textViews[TestAccessibilityIdentifiers.SendLetter.messageTextEditor]
   
        // 1. 존재 확인 (이미 성공)
        XCTAssertTrue(messageTextEditor.waitForExistence(timeout: 3))
       
        // 2. 바로 coordinate 탭 (오류 회피)
        messageTextEditor.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
       
        // 3. 텍스트 입력 및 검증
        let testMessage = "안녕하세요, 테스트 메시지입니다!"
        messageTextEditor.typeText(testMessage)

        // 4. 비행기 날리기 버튼 탭
        let sendFlyButton = findFlyButton()
        XCTAssertTrue(sendFlyButton.exists, "SendLetterView의 날리기 버튼이 존재하지 않음")
        sendFlyButton.tap()
        
        // 5. FlyAnimationView로 이동 확인
        let completionText = app.staticTexts[TestAccessibilityIdentifiers.FlyAnimation.completionText]
        XCTAssertTrue(completionText.waitForExistence(timeout: 8), "FlyAnimationView의 완료 텍스트가 나타나지 않음")
        
        // 애니메이션 진행 중 텍스트 확인
        XCTAssertEqual(completionText.label, "열심히 날아가는 중...", "초기 애니메이션 텍스트가 올바르지 않음")
        
        // 6. 애니메이션 완료 후 홈 버튼 확인
        let homeButton = findButton(identifier: TestAccessibilityIdentifiers.Common.bottomButton)
        XCTAssertTrue(homeButton.waitForExistence(timeout: 6), "애니메이션 완료 후 홈 버튼이 나타나지 않음")
        
        // 완료 텍스트 변경 확인
        XCTAssertEqual(completionText.label, "전송 완료!", "완료 후 텍스트가 올바르지 않음")
        
        // 홈 버튼 탭하여 MainView로 돌아가기
        homeButton.tap()
        
        // 7. MainView로 돌아갔는지 확인
        let returnedMainButton = findButton(identifier: TestAccessibilityIdentifiers.Main.flyButton)
        XCTAssertTrue(returnedMainButton.waitForExistence(timeout: 3), "홈 버튼 탭 후 MainView로 돌아가지 않음")
    }
    
    /// 커스텀 주제 입력을 사용한 네비게이션 테스트
    func testNavigationWithCustomTopic() throws {
        // 1. MainView에서 시작
        let mainFlyButton = findButton(identifier: TestAccessibilityIdentifiers.Common.bottomButton)
        mainFlyButton.tap()
        
        // 2. SelectSubjectView에서 커스텀 주제 입력
        let customTopicTextField = app.textFields[TestAccessibilityIdentifiers.SelectSubject.customTopicTextField]
        XCTAssertTrue(customTopicTextField.waitForExistence(timeout: 5), "커스텀 주제 입력 필드가 나타나지 않음")
        
        customTopicTextField.tap()
        customTopicTextField.typeText("나만의 커스텀 주제")
        
        // 다음 버튼 탭
        let nextButton = findNextButton()
        XCTAssertTrue(nextButton.isEnabled, "커스텀 주제 입력 후 다음 버튼이 활성화되지 않음")
        nextButton.tap()
        
        // 3. SendLetterView에서 주제가 올바르게 표시되는지 확인
        let topicLabel = app.staticTexts["주제: \"나만의 커스텀 주제\""]
        XCTAssertTrue(topicLabel.waitForExistence(timeout: 3), "커스텀 주제가 올바르게 표시되지 않음")
    }
    
    /// 필수 정보 미입력 시 네비게이션 차단 테스트
    func testNavigationBlockingWithMissingInfo() throws {
        // 1. MainView에서 SelectSubjectView로 이동
        let mainFlyButton = findButton(identifier: TestAccessibilityIdentifiers.Common.bottomButton)
        mainFlyButton.tap()
        
        // 2. 주제 선택 없이 다음 버튼 탭 시도
        let nextButton = findNextButton()
        XCTAssertTrue(nextButton.waitForExistence(timeout: 5), "다음 버튼이 나타나지 않음")
        
        // 주제를 선택하지 않으면 다음으로 이동하지 않아야 함
        nextButton.tap()
        
        // 여전히 SelectSubjectView에 있어야 함
        XCTAssertTrue(nextButton.exists, "주제 미선택 시에도 다음 화면으로 이동함")
        
        // 3. 주제 선택 후 SendLetterView로 이동
        let firstTopicButton = app.buttons[TestAccessibilityIdentifiers.SelectSubject.topicButton].firstMatch
        firstTopicButton.tap()
        nextButton.tap()
        
        // 4. SendLetterView에서 정보 미입력 시 날리기 버튼 동작 테스트
        let sendFlyButton = findFlyButton()
        XCTAssertTrue(sendFlyButton.waitForExistence(timeout: 5), "날리기 버튼이 나타나지 않음")
        
        // 받는 사람과 메시지 없이 날리기 버튼 탭 시도
        sendFlyButton.tap()
        
        // FlyAnimationView로 이동하지 않아야 함
        let completionText = app.staticTexts[TestAccessibilityIdentifiers.FlyAnimation.completionText]
        XCTAssertFalse(completionText.waitForExistence(timeout: 2), "필수 정보 미입력 시에도 애니메이션 화면으로 이동함")
    }
    
    /// 백 버튼을 통한 네비게이션 테스트
    func testBackButtonNavigation() throws {
        // 1. MainView -> SelectSubjectView
        let mainFlyButton = findButton(identifier: TestAccessibilityIdentifiers.Common.bottomButton)
        mainFlyButton.tap()
        
        // 2. SelectSubjectView에서 백 버튼 탭
        let selectSubjectBackButton = app.buttons[TestAccessibilityIdentifiers.Common.backButton]
        XCTAssertTrue(selectSubjectBackButton.waitForExistence(timeout: 5), "SelectSubjectView의 백 버튼이 나타나지 않음")
        selectSubjectBackButton.tap()
        
        // MainView로 돌아갔는지 확인
        XCTAssertTrue(mainFlyButton.waitForExistence(timeout: 3), "백 버튼 탭 후 MainView로 돌아가지 않음")
        
        // 3. MainView -> SelectSubjectView -> SendLetterView
        mainFlyButton.tap()
        let firstTopicButton = app.buttons[TestAccessibilityIdentifiers.SelectSubject.topicButton].firstMatch
        firstTopicButton.tap()
        let nextButton = findNextButton()
        nextButton.tap()
        
        // 4. SendLetterView에서 백 버튼 탭
        let sendLetterBackButton = app.buttons[TestAccessibilityIdentifiers.Common.backButton]
        XCTAssertTrue(sendLetterBackButton.waitForExistence(timeout: 5), "SendLetterView의 백 버튼이 나타나지 않음")
        sendLetterBackButton.tap()
        
        // SelectSubjectView로 돌아갔는지 확인
        XCTAssertTrue(nextButton.waitForExistence(timeout: 3), "백 버튼 탭 후 SelectSubjectView로 돌아가지 않음")
    }
}
