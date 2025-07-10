//
//  Report.swift
//  Fly to You
//
//  Created by 최희진 on 7/10/25.
//
import Foundation

struct Report: Codable {
    let id: String
    let reporterId: String
    let type: String
    let content: String
    let letterId: String
    let createdAt: Date
}
