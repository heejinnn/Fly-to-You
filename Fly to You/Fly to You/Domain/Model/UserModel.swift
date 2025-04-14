//
//  UserModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import Foundation

struct UserModel: Codable {
    let uid: String
    let nickname: String
    let createdAt: Date
}
