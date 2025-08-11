//
//  Report.swift
//  Fly to You
//
//  Created by 최희진 on 7/10/25.
//
import Foundation

struct Report: Codable {
    let id: String
    let reporterId: String// 신고하는 사람의 ID
    let reportedId: String// 신고받는 사람의 ID
    let type: String
    let content: String
    let letterId: String
    let createdAt: Date
}
