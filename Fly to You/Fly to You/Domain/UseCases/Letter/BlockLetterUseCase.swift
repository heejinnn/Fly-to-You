//
//  BlockLetterUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 8/11/25.
//

protocol BlockLetterUseCase {
    func blockLetter(letterId: String) async throws
}

final class DefaultBlockLetterUseCase: BlockLetterUseCase {
    
    private let letterRepo: LetterRepo
    
    init(letterRepo: LetterRepo) {
        self.letterRepo = letterRepo
    }
    
    func blockLetter(letterId: String) async throws {
        try await letterRepo.blockLetter(letterId: letterId)
    }
}
