//
//  SendLetterViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


protocol SendLetterViewModelInput{
    func sendLetter(toText: String, topic: String, topicId: String, message: String, completion: @escaping (Result<String, Error>) -> Void)
}

protocol SendLetterViewModelOutput{
    
}

protocol SendLetterViewModel: SendLetterViewModelInput, SendLetterViewModelOutput{}


class DefaultSendLetterViewModel: SendLetterViewModel{
    
    private let sendLetterUseCase: SendLetterUseCase
    
    init(sendLetterUseCase: SendLetterUseCase) {
        self.sendLetterUseCase = sendLetterUseCase
    }
    
    func sendLetter(toText: String, topic: String, topicId: String, message: String, completion: @escaping (Result<String, Error>) -> Void) {
        sendLetterUseCase.sendLetter(toText: toText, topic: topic, topicId: topicId, message: message, completion: completion)
    }
}
