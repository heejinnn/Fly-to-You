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
    func sendLetter(toUID: String, topic: String, topicId: String, message: String, completion: @escaping (Error?) -> Void)
}

protocol SendLetterViewModelOutput{
    
}

protocol SendLetterViewModel: SendLetterViewModelInput, SendLetterViewModelOutput{}


class DefaultSendLetterViewModel: SendLetterViewModel{
    
    private let sendLetterUseCase: SendLetterUseCase
    
    init(sendLetterUseCase: SendLetterUseCase) {
        self.sendLetterUseCase = sendLetterUseCase
    }
    
    func sendLetter(toUID: String, topic: String, topicId: String, message: String, completion: @escaping (Error?) -> Void) {
        
    }
}
