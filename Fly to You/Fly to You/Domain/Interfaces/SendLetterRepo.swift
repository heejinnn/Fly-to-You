//
//  SendLetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

protocol SendLetterRepo{
    func sendLetter(toText: String, topic: String, topicId: String, message: String, completion: @escaping (Result<String, Error>) -> Void)
}
