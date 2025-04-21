//
//  Letter.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import Foundation

struct Letter: Codable {
    let id: String
    let fromUid: String
    let toUid: String
    let message: String
    let topic: String
    let topicId: String
    let timestamp: Date
    let isDelivered: Bool
    let isRelayStart: Bool
}

extension Letter {
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "fromUid": fromUid,
            "toUid": toUid,
            "topic": topic,
            "topicId": topicId,
            "message": message,
            "timestamp": timestamp,
            "isDelivered": isDelivered,
            "isRelayStart": isRelayStart
        ]
    }
    
    func toDeleteFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "fromUid": fromUid,
            "toUid": toUid,
            "topic": topic,
            "topicId": topicId,
            "message": message,
            "timestamp": timestamp,
            "isDelivered": false,
            "isRelayStart": isRelayStart
        ]
    }
    
    func toReceiveLetterDto(data: Letter) -> ReceiveLetterDto {
        return ReceiveLetterDto(
            id: data.id,
            fromUid: data.fromUid,
            toUid: data.toUid,
            message: data.message,
            topic: data.topic,
            topicId: data.topicId,
            timestamp: data.timestamp,
            isDelivered: data.isDelivered,
            isRelayStart: data.isRelayStart)
    }
}
