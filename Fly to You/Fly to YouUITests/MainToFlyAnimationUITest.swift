//
//  MainToFlyAnimationUITest.swift
//  Fly to YouUITests
//
//  Created by Claude on 8/19/25.
//

import XCTest

final class MainToFlyAnimationUITest: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication.launchForUITest()
        
        // 앱이 MainView까지 로드될 때까지 대기
        sleep(3)
        
        // 디버깅: 현재 화면의 모든 버튼을 출력
        app.debugPrintButtons()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    //MARK: - Navigation Tests
    
    /// MainView에서 SelectSubjectView로의 네비게이션만 테스트
    @MainActor
    func testNavigationFromMainToSelectSubject() throws {
        // Given: MainView에서 시작
        let mainFlyButton = findButton(identifier: TestAccessibilityIdentifiers.Common.bottomButton)
        XCTAssertTrue(mainFlyButton.exists, "MainView의 비행기 날리기 버튼이 존재하지 않음")
        
        // When: 비행기 날리기 버튼 탭
        mainFlyButton.tap()
        
        // Then: SelectSubjectView로 이동 확인
        let nextButton = findNextButton()
        XCTAssertTrue(nextButton.waitForExistence(timeout: 5), "SelectSubjectView로 네비게이션되지 않음")
    }
    
    /// SelectSubjectView에서 SendLetterView로의 네비게이션만 테스트
    @MainActor
    func testNavigationFromSelectSubjectToSendLetter() throws {
        // Given: 주제가 선택된 SelectSubjectView 상태
        navigateToSelectSubjectView()
        selectFirstTopic()
        
        // When: 다음 버튼 탭
        navigateToSendLetterView()
        
        // Then: SendLetterView로 이동 확인
        let toUserButton = app.buttons[TestAccessibilityIdentifiers.SendLetter.toUserButton]
        XCTAssertTrue(toUserButton.waitForExistence(timeout: 5), "SendLetterView로 네비게이션되지 않음")
    }
    
    /// SendLetterView에서 FlyAnimationView로의 네비게이션만 테스트
    @MainActor
    func testNavigationFromSendLetterToFlyAnimation() throws {
        // Given: 모든 정보가 입력된 SendLetterView 상태
        navigateToSelectSubjectView()
        selectFirstTopic()
        navigateToSendLetterView()
        selectFirstUser()
        _ = enterTestMessage()
        
        // When: 날리기 버튼 탭
        navigateToFlyAnimationView()
        
        // Then: FlyAnimationView로 이동 확인
        let completionText = app.staticTexts[TestAccessibilityIdentifiers.FlyAnimation.completionText]
        XCTAssertTrue(completionText.waitForExistence(timeout: 8), "FlyAnimationView로 네비게이션되지 않음")
    }
    
    /// FlyAnimationView에서 MainView로의 네비게이션만 테스트
    @MainActor
    func testNavigationFromFlyAnimationToMain() throws {
        // Given: 애니메이션이 완료된 FlyAnimationView 상태
        navigateToSelectSubjectView()
        selectFirstTopic()
        navigateToSendLetterView()
        selectFirstUser()
        _ = enterTestMessage()
        navigateToFlyAnimationView()
        
        // 애니메이션 완료까지 대기
        let homeButton = findButton(identifier: TestAccessibilityIdentifiers.Common.bottomButton)
        XCTAssertTrue(homeButton.waitForExistence(timeout: 6), "홈 버튼이 나타나지 않음")
        
        // When: 홈 버튼 탭
        homeButton.tap()
        
        // Then: MainView로 돌아갔는지 확인
        let returnedMainButton = findButton(identifier: TestAccessibilityIdentifiers.Common.bottomButton)
        XCTAssertTrue(returnedMainButton.waitForExistence(timeout: 3), "MainView로 네비게이션되지 않음")
    }
    
    /// SelectSubjectView에서 MainView로의 백 네비게이션만 테스트
    @MainActor
    func testBackNavigationFromSelectSubjectToMain() throws {
        // Given: SelectSubjectView에서 시작
        navigateToSelectSubjectView()
        
        // When: 백 버튼 탭
        let selectSubjectBackButton = app.buttons[TestAccessibilityIdentifiers.Common.backButton]
        XCTAssertTrue(selectSubjectBackButton.waitForExistence(timeout: 5), "SelectSubjectView의 백 버튼이 나타나지 않음")
        selectSubjectBackButton.tap()
        
        // Then: MainView로 돌아갔는지 확인
        let mainFlyButton = findButton(identifier: TestAccessibilityIdentifiers.Common.bottomButton)
        XCTAssertTrue(mainFlyButton.waitForExistence(timeout: 3), "백 버튼 탭 후 MainView로 돌아가지 않음")
    }
    
    /// SendLetterView에서 SelectSubjectView로의 백 네비게이션만 테스트
    @MainActor
    func testBackNavigationFromSendLetterToSelectSubject() throws {
        // Given: SendLetterView에서 시작
        navigateToSelectSubjectView()
        selectFirstTopic()
        navigateToSendLetterView()
        
        // When: 백 버튼 탭
        let sendLetterBackButton = app.buttons[TestAccessibilityIdentifiers.Common.backButton]
        XCTAssertTrue(sendLetterBackButton.waitForExistence(timeout: 5), "SendLetterView의 백 버튼이 나타나지 않음")
        sendLetterBackButton.tap()
        
        // Then: SelectSubjectView로 돌아갔는지 확인
        let nextButton = findNextButton()
        XCTAssertTrue(nextButton.waitForExistence(timeout: 3), "백 버튼 탭 후 SelectSubjectView로 돌아가지 않음")
    }
    
    //MARK: - UI Feature Tests
    
    /// 첫 번째 주제 선택 기능만 테스트
    @MainActor
    func testFirstTopicSelection() throws {
        // Given: SelectSubjectView에서 시작
        navigateToSelectSubjectView()
        
        let nextButton = findNextButton()
        XCTAssertTrue(nextButton.waitForExistence(timeout: 5), "SelectSubjectView 로딩 실패")
        
        // 초기 상태에서는 다음 버튼이 비활성화되어 있어야 함
        XCTAssertFalse(nextButton.isEnabled, "초기 상태에서 다음 버튼이 활성화되어 있음")
        
        // When: 첫 번째 주제 선택
        selectFirstTopic()
        
        // Then: 다음 버튼이 활성화되어야 함
        XCTAssertTrue(nextButton.isEnabled, "주제 선택 후 다음 버튼이 활성화되지 않음")
    }
    
    /// 커스텀 주제 입력 기능만 테스트
    @MainActor
    func testCustomTopicInput() throws {
        // Given: SelectSubjectView에서 시작
        navigateToSelectSubjectView()
        
        // When: 커스텀 주제 입력
        enterCustomTopic()
        
        // Then: 다음 버튼이 활성화되어야 함
        let nextButton = findNextButton()
        XCTAssertTrue(nextButton.isEnabled, "커스텀 주제 입력 후 다음 버튼이 활성화되지 않음")
    }
    
    /// 커스텀 주제 표시 기능만 테스트
    @MainActor
    func testCustomTopicDisplay() throws {
        // Given: 커스텀 주제가 입력된 상태
        navigateToSelectSubjectView()
        enterCustomTopic()
        
        // Then: 커스텀 주제 입력
        navigateToSendLetterView()
        
        // Then: SendLetterView에서 주제가 올바르게 표시되는지 확인
        let topicLabel = app.staticTexts["주제: \"나만의 커스텀 주제\""]
        XCTAssertTrue(topicLabel.waitForExistence(timeout: 3), "커스텀 주제가 올바르게 표시되지 않음")
    }
    
    /// 사용자 선택 기능만 테스트
    @MainActor
    func testUserSelection() throws {
        // Given: SendLetterView에서 시작
        navigateToSelectSubjectView()
        selectFirstTopic()
        navigateToSendLetterView()
        
        // When: 첫 번째 사용자 선택
        selectFirstUser()
        
        // Then: 사용자 선택이 완료되었는지 확인 (여기서는 시트가 닫혔는지로 판단)
        let firstUserButton = app.buttons[TestAccessibilityIdentifiers.SendLetter.userListButton].firstMatch
        XCTAssertFalse(firstUserButton.exists, "사용자 선택 후 시트가 닫히지 않음")
    }
    
    /// 메시지 입력 기능만 테스트
    @MainActor
    func testMessageInput() throws {
        // Given: 사용자가 선택된 SendLetterView 상태
        navigateToSelectSubjectView()
        selectFirstTopic()
        navigateToSendLetterView()
        selectFirstUser()
        
        // When: 메시지 입력
        let testMessage = enterTestMessage()
        
        // Then: 메시지가 올바르게 입력되었는지 확인
        let messageTextEditor = app.textViews[TestAccessibilityIdentifiers.SendLetter.messageTextEditor]
        XCTAssertEqual(messageTextEditor.value as? String, testMessage, "메시지가 올바르게 입력되지 않음")
    }
    
    /// 애니메이션 진행 상태 표시만 테스트
    @MainActor
    func testAnimationProgressDisplay() throws {
        // Given: FlyAnimationView가 표시된 상태
        navigateToSelectSubjectView()
        selectFirstTopic()
        navigateToSendLetterView()
        selectFirstUser()
        _ = enterTestMessage()
        navigateToFlyAnimationView()
        
        // When: 애니메이션 시작
        let completionText = app.staticTexts[TestAccessibilityIdentifiers.FlyAnimation.completionText]
        XCTAssertTrue(completionText.waitForExistence(timeout: 8), "애니메이션 텍스트가 나타나지 않음")
        
        // Then: 진행 중 텍스트 확인
        XCTAssertEqual(completionText.label, "열심히 날아가는 중...", "애니메이션 진행 텍스트가 올바르지 않음")
    }
    
    /// 애니메이션 완료 상태 표시만 테스트
    @MainActor
    func testAnimationCompletionDisplay() throws {
        // Given: 애니메이션이 진행 중인 상태
        navigateToSelectSubjectView()
        selectFirstTopic()
        navigateToSendLetterView()
        selectFirstUser()
        _ = enterTestMessage()
        navigateToFlyAnimationView()
        
        let completionText = app.staticTexts[TestAccessibilityIdentifiers.FlyAnimation.completionText]
        XCTAssertTrue(completionText.waitForExistence(timeout: 8), "애니메이션 텍스트가 나타나지 않음")
        
        // When: 애니메이션 완료 대기
        let homeButton = findButton(identifier: TestAccessibilityIdentifiers.Common.bottomButton)
        XCTAssertTrue(homeButton.waitForExistence(timeout: 6), "홈 버튼이 나타나지 않음")
        
        // Then: 완료 텍스트 확인
        XCTAssertEqual(completionText.label, "전송 완료!", "애니메이션 완료 텍스트가 올바르지 않음")
    }
    
    /// 주제 미선택 시 유효성 검사만 테스트
    @MainActor
    func testTopicSelectionValidation() throws {
        // Given: SelectSubjectView에서 시작
        navigateToSelectSubjectView()
        
        // When: 주제 선택 없이 다음 버튼 상태 확인
        let nextButton = findNextButton()
        XCTAssertTrue(nextButton.waitForExistence(timeout: 5), "다음 버튼이 나타나지 않음")
        
        // Then: 주제를 선택하지 않으면 다음 버튼이 비활성화되어야 함
        XCTAssertFalse(nextButton.isEnabled, "주제 미선택 시 다음 버튼이 활성화되면 안됨")
    }
    
    /// 필수 정보 미입력 시 날리기 버튼 유효성 검사만 테스트
    @MainActor
    func testSendLetterValidationWithMissingInfo() throws {
        // Given: 주제만 선택된 SendLetterView 상태 (받는 사람, 메시지 없음)
        navigateToSelectSubjectView()
        selectFirstTopic()
        navigateToSendLetterView()
        
        // When: 필수 정보 없이 날리기 버튼 탭
        let sendFlyButton = findFlyButton()
        XCTAssertTrue(sendFlyButton.waitForExistence(timeout: 5), "날리기 버튼이 나타나지 않음")
        sendFlyButton.tap()
        
        // Then: FlyAnimationView로 이동하지 않아야 함
        let completionText = app.staticTexts[TestAccessibilityIdentifiers.FlyAnimation.completionText]
        XCTAssertFalse(completionText.waitForExistence(timeout: 2), "필수 정보 미입력 시에도 애니메이션 화면으로 이동함")
    }
    
}

// MARK: - Helper Methods Extensions
extension MainToFlyAnimationUITest {
    
    // MARK: - Navigation Helper Methods
    
    /// MainView -> SelectSubjectView로 이동
    @MainActor
    private func navigateToSelectSubjectView() {
        let mainFlyButton = findButton(identifier: TestAccessibilityIdentifiers.Common.bottomButton)
        XCTAssertTrue(mainFlyButton.exists, "MainView의 비행기 날리기 버튼이 존재하지 않음")
        mainFlyButton.tap()
    }
    
    /// SelectSubjectView -> SendLetterView로 이동
    @MainActor
    private func navigateToSendLetterView() {
        let nextButton = findNextButton()
        XCTAssertTrue(nextButton.isEnabled, "주제 선택 후 다음 버튼이 활성화되지 않음")
        nextButton.tap()
    }
    
    /// SendLetterView -> FlyAnimationView로 이동
    @MainActor
    private func navigateToFlyAnimationView() {
        let sendFlyButton = findFlyButton()
        XCTAssertTrue(sendFlyButton.exists, "SendLetterView의 날리기 버튼이 존재하지 않음")
        sendFlyButton.tap()
    }
    
    // MARK: - Action Helper Methods
    
    /// 첫 번째 주제 선택
    @MainActor
    private func selectFirstTopic() {
        let firstTopicButton = app.buttons[TestAccessibilityIdentifiers.SelectSubject.topicButton].firstMatch
        XCTAssertTrue(firstTopicButton.waitForExistence(timeout: 3), "첫 번째 주제 버튼이 나타나지 않음")
        firstTopicButton.tap()
    }
    
    /// 커스텀 주제 입력
    @MainActor
    private func enterCustomTopic() {
        let customTopicTextField = app.textFields[TestAccessibilityIdentifiers.SelectSubject.customTopicTextField]
        XCTAssertTrue(customTopicTextField.waitForExistence(timeout: 5), "커스텀 주제 입력 필드가 나타나지 않음")
        
        customTopicTextField.tap()
        customTopicTextField.typeText("나만의 커스텀 주제")
    }
    
    /// 첫 번째 사용자 선택
    @MainActor
    private func selectFirstUser() {
        let toUserButton = app.buttons[TestAccessibilityIdentifiers.SendLetter.toUserButton]
        XCTAssertTrue(toUserButton.waitForExistence(timeout: 5), "SendLetterView의 받는 사람 버튼이 나타나지 않음")
        
        // 받는 사람 선택 (UserListSheet 열기)
        toUserButton.tap()
        
        // 시트가 열렸는지 확인
        let firstUserButton = app.buttons[TestAccessibilityIdentifiers.SendLetter.userListButton].firstMatch
        XCTAssertTrue(firstUserButton.waitForExistence(timeout: 5), "사용자 목록 시트의 첫 번째 사용자 버튼이 나타나지 않음")
        
        // 사용자 선택
        firstUserButton.tap()
        
        // 시트 닫기 (스와이프)
        let startCoordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.4))
        let endCoordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        startCoordinate.press(forDuration: 0.2, thenDragTo: endCoordinate)
        
        XCTAssertTrue(firstUserButton.waitForNonExistence(timeout: 3), "스와이프로 시트가 닫히지 않음")
    }
    
    /// 테스트 메시지 입력
    @MainActor
    private func enterTestMessage() -> String {
        let messageTextEditor = app.textViews[TestAccessibilityIdentifiers.SendLetter.messageTextEditor]
        XCTAssertTrue(messageTextEditor.waitForExistence(timeout: 3), "메시지 입력 필드가 나타나지 않음")
        
        // coordinate 탭
        messageTextEditor.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        
        let testMessage = "안녕하세요, 테스트 메시지입니다!"
        messageTextEditor.typeText(testMessage)
        
        return testMessage
    }
    
    // MARK: - UI Element Finder Methods
    
    /// identifier로 버튼 찾기
    private func findButton(identifier: String) -> XCUIElement {
        return app.buttons[identifier]
    }
    
    /// 다음 버튼 찾기
    private func findNextButton() -> XCUIElement {
        let nextById = app.buttons[TestAccessibilityIdentifiers.SelectSubject.nextButton]
        return nextById.exists ? nextById : app.buttons["다음"]
    }
    
    /// 날리기 버튼 찾기 (fallback 포함)
    private func findFlyButton() -> XCUIElement {
        let flyById = app.buttons[TestAccessibilityIdentifiers.SendLetter.flyButton]
        return flyById.exists ? flyById : app.staticTexts["날리기"].firstMatch
    }
}
