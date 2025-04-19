//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import Foundation

struct ReceiveLetter: Identifiable, Codable {
    let id: String
    let from: User?
    let to: User?
    let message: String
    let topic: String
    let topicId: String
    let timestamp: Date
    let isDelivered: Bool
    let isRelayStart: Bool
}

extension ReceiveLetter {
    static func toReceiveLetterModels(letters: [ReceiveLetter]) -> [ReceiveLetterModel] {
        letters.map { letter in
            ReceiveLetterModel(
                id: letter.id,
                from: letter.from ?? User(uid: "", nickname: "", createdAt: Date()),
                to: letter.to ?? User(uid: "", nickname: "", createdAt: Date()),
                message: letter.message,
                topic: letter.topic,
                topicId: letter.topicId,
                timestamp: letter.timestamp,
                isDelivered: letter.isDelivered,
                isRelayStart: letter.isRelayStart
            )
        }
    }
    
    static func toReceiveLetterModel(letter: ReceiveLetter) -> ReceiveLetterModel {
        return ReceiveLetterModel(
            id: letter.id,
            from: letter.from ?? User(uid: "", nickname: "", createdAt: Date()),
            to: letter.to ?? User(uid: "", nickname: "", createdAt: Date()),
            message: letter.message,
            topic: letter.topic,
            topicId: letter.topicId,
            timestamp: letter.timestamp,
            isDelivered: letter.isDelivered,
            isRelayStart: letter.isRelayStart
        )
        
    }
}
