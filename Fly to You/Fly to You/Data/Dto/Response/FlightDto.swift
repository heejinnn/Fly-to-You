//
//  FlightDto.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import Foundation

struct FlightDto: Codable {
    let id: String
    let topic: String
    let startDate: Date
    let routes: [Letter]
}
