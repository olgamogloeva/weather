//
//  CurrentWeatherResponse.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import Foundation

struct CurrentWeatherResponse: Codable {
    let identifier: Int
    let name: String
    let timezone: Int
    let coordinate: Coordinate
    let weather: [Condition]
    let main: Main
    let wind: Wind
    let cloudCoverage: CloudCoverage
    let dateTimeUnix: Int
    let metadata: Metadata

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case timezone
        case coordinate = "coord"
        case weather = "weather"
        case main
        case wind
        case cloudCoverage = "clouds"
        case dateTimeUnix = "dt"
        case metadata = "sys"
    }
}

// MARK: - Metadata
struct Metadata: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int
}
