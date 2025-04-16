//
//  SendLetterUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//


protocol SendLetterUseCase{
    func sendLetter(toText: String, topic: String, topicId: String, message: String, completion: @escaping (Result<String, Error>) -> Void)
}

class DefaultSendLetterUseCase: SendLetterUseCase{
    
    private let repository: SendLetterRepo
    
    init( repository: SendLetterRepo) {
        self.repository = repository
    }
    
    func sendLetter(toText: String, topic: String, topicId: String, message: String, completion: @escaping (Result<String, Error>) -> Void) {
        repository.sendLetter(toText: toText, topic: topic, topicId: topicId, message: message, completion: completion)
    }
}
