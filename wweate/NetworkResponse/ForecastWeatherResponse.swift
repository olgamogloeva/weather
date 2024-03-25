//
//  ForecastWeatherResponse.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

struct ForecastWeatherResponse: Codable {
    let data: [ForecastData]

    enum CodingKeys: String, CodingKey {
        case data = "list"
    }
}

// MARK: - ForecastData
struct ForecastData: Codable {
    let dateTimeUnix: Int
    let main: Main
    let conditions: [Condition]
    let cloudCoverage: CloudCoverage
    let wind: Wind
    let probabilityOfPrecipitation: Double
    let partOfDay: Sys

    enum CodingKeys: String, CodingKey {
        case dateTimeUnix = "dt"
        case main
        case conditions = "weather"
        case cloudCoverage = "clouds"
        case wind
        case probabilityOfPrecipitation = "pop"
        case partOfDay = "sys"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: DayNightState
}

enum DayNightState: String, Codable, CustomStringConvertible {
    case day = "d"
    case night = "n"

    var description: String {
        switch self {
        case .day:
            return "day"

        case .night:
            return "night"
        }
    }
}
