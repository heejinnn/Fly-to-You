//
//  SessionStorage.swift
//  Fly to You
//
//  Created by 최희진 on 12/30/24.
//

import Foundation

protocol SessionStorage {
    func save(key: String, value: String)
    func load(key: String) -> String?
    func remove(key: String)
    func clear()
}
