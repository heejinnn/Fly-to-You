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
    func sendLetter(toUid: String, topicData: TopicModel, message: String, completion: @escaping (Result<Letter, Error>) -> Void)
    func fetchReportedCount() async throws -> Bool
}

protocol SendLetterViewModelOutput{
    
}

protocol SendLetterViewModel: SendLetterViewModelInput, SendLetterViewModelOutput{}


class DefaultSendLetterViewModel: SendLetterViewModel{
    
    private let sendLetterUseCase: SendLetterUseCase
    
    init(sendLetterUseCase: SendLetterUseCase) {
        self.sendLetterUseCase = sendLetterUseCase
    }
    
    func sendLetter(toUid: String, topicData: TopicModel, message: String, completion: @escaping (Result<Letter, Error>) -> Void) {
        
        Task {
            do {
                let result = try await sendLetterUseCase.send(
                    toUid: toUid,
                    topic: topicData.topic,
                    topicId: topicData.topicId,
                    message: message
                )
                completion(.success(result))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchReportedCount() async throws -> Bool{
        try await sendLetterUseCase.fetchReportedCount()
    }
}
