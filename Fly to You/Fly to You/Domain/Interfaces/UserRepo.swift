//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

protocol UserRepo{
    func fetchUid(nickname: String) async throws -> String
    func currentUserUid() async throws -> String
}



