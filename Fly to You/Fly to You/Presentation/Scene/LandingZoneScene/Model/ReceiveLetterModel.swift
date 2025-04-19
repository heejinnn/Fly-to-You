//
//  ReceiveLetter.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import Foundation

struct ReceiveLetterModel: Identifiable, Codable {
    let id: String
    let from: User
    let to: User
    let message: String
    let topic: String
    let topicId: String
    let timestamp: Date
    let isDelivered: Bool
    let isRelayStart: Bool
}

extension ReceiveLetterModel {
    static func toLetter(data: ReceiveLetterModel) -> Letter {
        return Letter(
            id: data.id,
            fromUid: data.from.uid,
            toUid: data.to.uid,
            message: data.message,
            topic: data.topic,
            topicId: data.topicId,
            timestamp: data.timestamp,
            isDelivered: data.isDelivered,
            isRelayStart: data.isRelayStart
        )
    }
}
