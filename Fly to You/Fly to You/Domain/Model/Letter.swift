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
            "timestamp": timestamp
        ]
    }
}
