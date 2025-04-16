//
//  SendLetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

protocol SendLetterRepo{
    func sendLetter(toUID: String, topic: String, topicId: String, message: String, completion: @escaping (Error?) -> Void)
}
