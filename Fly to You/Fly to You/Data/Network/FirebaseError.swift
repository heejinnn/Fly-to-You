//
//  Error.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import Foundation

public enum FirebaseError: LocalizedError {
    case validationError(message: String)
    case repositoryError(cause: Error)
    
    public var errorDescription: String? {
        switch self {
        case .validationError(let msg): return msg
        case .repositoryError(let cause): return cause.localizedDescription
        }
    }
}
