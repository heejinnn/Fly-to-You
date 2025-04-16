//
//  SendLetterUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//


protocol SendLetterUseCase{
    func sendLetter(toUID: String, topic: String, topicId: String, message: String, completion: @escaping (Error?) -> Void)
}

class DefaultSendLetterUseCase: SendLetterUseCase{
    
    private let repository: SendLetterRepo
    
    init( repository: SendLetterRepo) {
        self.repository = repository
    }
    
    func sendLetter(toUID: String, topic: String, topicId: String, message: String, completion: @escaping (Error?) -> Void) {
        repository.
    }
    
}
