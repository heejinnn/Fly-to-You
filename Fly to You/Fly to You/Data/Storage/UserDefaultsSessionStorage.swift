//
//  UserDefaultsSessionStorage.swift
//  Fly to You
//
//  Created by Claude on 12/30/24.
//

import Foundation

final class UserDefaultsSessionStorage: SessionStorage {
    func save(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func load(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func clear() {
        let keys = ["uid", "nickname"]
        keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
    }
}