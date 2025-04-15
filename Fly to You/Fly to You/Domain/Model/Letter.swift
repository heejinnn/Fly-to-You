//
//  Letter.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import Foundation

struct Letter: Codable, Identifiable {
    var id: String = UUID().uuidString
    var fromUID: String
    var toUID: String
    var message: String
    var topic: String
    var topicId: String
    var timestamp: Date
}
