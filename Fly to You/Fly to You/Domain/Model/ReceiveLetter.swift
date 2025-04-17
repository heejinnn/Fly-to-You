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
}

