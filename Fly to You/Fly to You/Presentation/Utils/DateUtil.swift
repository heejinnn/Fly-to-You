//
//  DateUtil.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import Foundation

enum DateUtil {
    static let letterDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    static func formatLetterDate(_ date: Date) -> String {
        return letterDateFormatter.string(from: date)
    }
}
