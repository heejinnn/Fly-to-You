//
//  Fly_to_YouUITests.swift
//  Fly to YouUITests
//
//  Created by 최희진 on 4/12/25.
//

import XCTest

final class Fly_to_YouUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testSignUpViewNicknameInput() throws {
        let app = XCUIApplication()
        // 로그아웃 상태로 강제 설정하여 SignUpView가 바로 나타나도록 함
        app.launchArguments += ["-forceLogout"]
        app.launch()
        
        // SignUpView의 닉네임 입력 필드 찾기
        let nicknameTextField = app.textFields["최대 10자까지 입력 가능"]
        XCTAssertTrue(nicknameTextField.waitForExistence(timeout: 3), "닉네임 입력 필드가 존재해야 합니다")
        
        // 닉네임 입력
        nicknameTextField.tap()
        nicknameTextField.typeText("테스트닉네임")
        
        // 입력된 텍스트 확인
        XCTAssertEqual(nicknameTextField.value as? String, "테스트닉네임", "입력한 닉네임이 표시되어야 합니다")
    }
    
    @MainActor
    func testSignUpViewEULACheckbox() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-forceLogout"]
        app.launch()
        
        // EULA 체크박스 찾기
        let eulaCheckbox = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'checkmark' OR identifier CONTAINS 'square'")).firstMatch
        XCTAssertTrue(eulaCheckbox.waitForExistence(timeout: 3), "EULA 체크박스가 존재해야 합니다")
        
        // 체크박스 클릭
        eulaCheckbox.tap()
        
        // EULA 상세보기 버튼 확인
        let eulaDetailButton = app.buttons["보기"]
        XCTAssertTrue(eulaDetailButton.exists, "EULA 상세보기 버튼이 존재해야 합니다")
    }
    
    @MainActor
    func testSignUpViewCompleteButtonState() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-forceLogout"]
        app.launch()
        
        // 완료 버튼 찾기
        let completeButton = app.buttons["완료"]
        XCTAssertTrue(completeButton.waitForExistence(timeout: 3), "완료 버튼이 존재해야 합니다")
        
        // 초기 상태에서는 완료 버튼이 비활성화되어 있어야 함
        XCTAssertFalse(completeButton.isEnabled, "초기 상태에서 완료 버튼은 비활성화되어야 합니다")
        
        // 닉네임 입력
        let nicknameTextField = app.textFields["최대 10자까지 입력 가능"]
        nicknameTextField.tap()
        nicknameTextField.typeText("테스트")
        
        // EULA 체크박스 클릭
        let eulaCheckbox = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'checkmark' OR identifier CONTAINS 'square'")).firstMatch
        eulaCheckbox.tap()
        
        // 완료 버튼이 활성화되어야 함
        XCTAssertTrue(completeButton.isEnabled, "닉네임 입력과 EULA 동의 후 완료 버튼이 활성화되어야 합니다")
    }
    
    @MainActor
    func testSignUpViewNicknameCharacterLimit() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-forceLogout"]
        app.launch()
        
        // 닉네임 입력 필드에 10자 초과 입력 시도
        let nicknameTextField = app.textFields["최대 10자까지 입력 가능"]
        XCTAssertTrue(nicknameTextField.waitForExistence(timeout: 3), "닉네임 입력 필드가 존재해야 합니다")
        nicknameTextField.tap()
        nicknameTextField.typeText("12345678901234567890") // 20자 입력
        
        // 10자로 제한되는지 확인 (실제 값은 앱 로직에 따라 10자로 제한됨)
        let textValue = nicknameTextField.value as? String ?? ""
        XCTAssertTrue(textValue.count <= 10, "닉네임은 10자를 초과할 수 없습니다")
    }
    
    @MainActor
    func testSignUpViewEULASheetPresentation() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-forceLogout"]
        app.launch()
        
        // EULA 상세보기 버튼 클릭
        let eulaDetailButton = app.buttons["보기"]
        XCTAssertTrue(eulaDetailButton.waitForExistence(timeout: 3), "EULA 상세보기 버튼이 존재해야 합니다")
        eulaDetailButton.tap()
        
        app.swipeUp()
        app.swipeDown()
        
//        // 시트가 나타나는지 확인 (실제 시트 내용은 EULADetailSheetView에 따라 다름)
//        // 시트가 표시되면 일반적으로 새로운 뷰나 모달이 나타남
//        let expectation = XCTestExpectation(description: "EULA 시트가 표시되어야 합니다")
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 2.0)
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

