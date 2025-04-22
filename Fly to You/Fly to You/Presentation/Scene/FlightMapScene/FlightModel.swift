//
//  FlightModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import Foundation

struct FlightModel: Identifiable, Codable {
    let id: String
    let topic: String
    let stratDate: Date
    let routes: [ReceiveLetterModel]
}
