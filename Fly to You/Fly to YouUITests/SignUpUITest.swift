//
//  SignUpUITest.swift
//  Fly to YouUITests
//
//  Created by 최희진 on 4/12/25.
//

import XCTest

final class SignUpUITest: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication.launchForSignUpTest()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testSignUpViewNicknameInput() throws {
        
        // Given: SignUpView의 닉네임 입력 필드 존재
        let nicknameTextField = app.textFields[TestAccessibilityIdentifiers.SignUp.nicknameTextField]
        XCTAssertTrue(nicknameTextField.waitForExistence(timeout: 10), "닉네임 입력 필드가 존재해야 합니다")
        
        // When: 닉네임 입력
        nicknameTextField.tap()
        nicknameTextField.typeText("테스트닉네임")
        
        // Then: 입력된 텍스트 확인
        XCTAssertEqual(nicknameTextField.value as? String, "테스트닉네임", "입력한 닉네임이 표시되어야 합니다")
    }
    
    @MainActor
    func testSignUpViewEULACheckbox() throws {
        
        // Given: EULA 체크박스 존재
        let eulaCheckbox = app.buttons[TestAccessibilityIdentifiers.SignUp.eulaCheckbox]
        XCTAssertTrue(eulaCheckbox.waitForExistence(timeout: 10), "EULA 체크박스가 존재해야 합니다")
        
        // When: 체크박스 클릭
        eulaCheckbox.tap()
        
        // Then: EULA 상세보기 버튼 존재 확인
        let eulaDetailButton = app.buttons[TestAccessibilityIdentifiers.SignUp.eulaDetailButton]
        XCTAssertTrue(eulaDetailButton.exists, "EULA 상세보기 버튼이 존재해야 합니다")
    }
    
    @MainActor
    func testSignUpViewCompleteButtonState() throws {
        
        // Given: 완료 버튼 존재
        let completeButton = app.buttons[TestAccessibilityIdentifiers.SignUp.completeButton]
        XCTAssertTrue(completeButton.waitForExistence(timeout: 10), "완료 버튼이 존재해야 합니다")
        
        // 초기 상태에서는 완료 버튼이 비활성화되어 있어야 함
        XCTAssertFalse(completeButton.isEnabled, "초기 상태에서 완료 버튼은 비활성화되어야 합니다")
        
        // When: 닉네임 입력, EULA 체크박스 클릭
        let nicknameTextField = app.textFields[TestAccessibilityIdentifiers.SignUp.nicknameTextField]
        nicknameTextField.tap()
        nicknameTextField.typeText("테스트")
    
        let eulaCheckbox = app.buttons[TestAccessibilityIdentifiers.SignUp.eulaCheckbox]
        eulaCheckbox.tap()
        
        // Then: 완료 버튼이 활성화되어야 함
        XCTAssertTrue(completeButton.isEnabled, "닉네임 입력과 EULA 동의 후 완료 버튼이 활성화되어야 합니다")
    }
    
    @MainActor
    func testSignUpViewNicknameCharacterLimit() throws {
        
        // Given: 닉네임 입력 필드 존재
        
        let nicknameTextField = app.textFields[TestAccessibilityIdentifiers.SignUp.nicknameTextField]
        XCTAssertTrue(nicknameTextField.waitForExistence(timeout: 3), "닉네임 입력 필드가 존재해야 합니다")
        
        // When: 닉네임 입력 필드에 10자 초과 입력 시도
        nicknameTextField.tap()
        nicknameTextField.typeText("12345678901234567890") // 20자 입력
        
        // Then: 10자로 제한되는지 확인
        let textValue = nicknameTextField.value as? String ?? ""
        XCTAssertTrue(textValue.count <= 10, "닉네임은 10자를 초과할 수 없습니다")
    }
    
    @MainActor
    func testSignUpViewEULASheetPresentation() throws {
        
        // Given: EULA 상세보기 버튼 존재
        let eulaDetailButton = app.buttons[TestAccessibilityIdentifiers.SignUp.eulaDetailButton]
        XCTAssertTrue(eulaDetailButton.waitForExistence(timeout: 10), "EULA 상세보기 버튼이 존재해야 합니다")
        eulaDetailButton.tap()
        
        // When: EULA 상세보기 버튼 클릭
        eulaDetailButton.tap()
        
        // Then: EULA 상세보기 화면 존재 확인
        let eulaSheet = app.scrollViews[TestAccessibilityIdentifiers.SignUp.eulaSheet]
        XCTAssertTrue(eulaSheet.waitForExistence(timeout: 10), "EULA 시트가 표시되어야 합니다")
        eulaSheet.swipeUp()
        eulaSheet.swipeDown()
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

