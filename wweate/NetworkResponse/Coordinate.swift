//
//  Coordinate.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import Foundation

struct Coordinate: Codable {
    let longitude: Double
    let latitude: Double

    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
