//
//  DeleteLetterUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/19/25.
//


protocol DeleteLetterUseCase {
    func deleteSentLetter(letter: Letter) async throws
}

final class DefaultDeleteLetterUseCase: DeleteLetterUseCase {
    
    private let letterRepo: LetterRepo
    
    init(letterRepo: LetterRepo) {
        self.letterRepo = letterRepo
    }
    
    func deleteSentLetter(letter: Letter) async throws {
        try await letterRepo.deleteSentLetter(letter: letter)
    }
}
