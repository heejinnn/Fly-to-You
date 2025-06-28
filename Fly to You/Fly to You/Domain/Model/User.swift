//
//  UserModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import Foundation

struct User: Codable {
    let uid: String
    let nickname: String
    let createdAt: Date
    let fcmToken: String
}
