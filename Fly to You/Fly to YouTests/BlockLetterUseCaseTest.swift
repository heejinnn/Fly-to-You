//
//  Fly_to_YouTests.swift
//  Fly to YouTests
//
//  Created by 최희진 on 4/12/25.
//

import XCTest
@testable import Fly_to_You

final class BlockLetterUseCaseTest: XCTestCase {
    
    var sut: DefaultBlockLetterUseCase!
    var mockLetterRepo: MockLetterRepo!

    override func setUpWithError() throws {
        mockLetterRepo = MockLetterRepo()
        sut = DefaultBlockLetterUseCase(letterRepo: mockLetterRepo)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockLetterRepo = nil
    }

    //정상적인 호출
    func test_blockLetter_success() async throws {
        //Given
        let letterId = "letter123"
    
        //When
    
        try await sut.blockLetter(letterId: letterId)
        
        //Then
        
        XCTAssertTrue(mockLetterRepo.blockLetterCalled)
        XCTAssertEqual(mockLetterRepo.receivedLetterId, letterId)
        
    }
    
    //빈 ID값인 경우 
    func test_blockLetter_emptyId() async throws{
        //Given
        let letterId = ""
        
        //When
        
        try await sut.blockLetter(letterId: letterId)
        
        //Then
        
        XCTAssertFalse(mockLetterRepo.blockLetterCalled)
        XCTAssertEqual(mockLetterRepo.receivedLetterId, "")
    }

    func testPerformanceExample() throws {
        
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
