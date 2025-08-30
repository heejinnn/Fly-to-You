//
//  SessionStorage.swift
//  Fly to You
//
//  Created by Claude on 12/30/24.
//

import Foundation

protocol SessionStorage {
    func save(key: String, value: String)
    func load(key: String) -> String?
    func remove(key: String)
    func clear()
}