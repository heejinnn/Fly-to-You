//
//  ReceiveLetterDTO.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import Foundation

struct ReceiveLetterDto: Identifiable, Codable {
    let id: String
    let fromUid: String
    let toUid: String
    let message: String
    let topic: String
    let topicId: String
    let timestamp: Date
    let isDelivered: Bool
}
