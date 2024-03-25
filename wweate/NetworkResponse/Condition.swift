//
//  Condition.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import Foundation

struct Condition: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
}
