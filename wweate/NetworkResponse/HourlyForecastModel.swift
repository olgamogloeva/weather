//
//  ForecastWeatherModel.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import Foundation

struct ForecastWeatherModel {
    let hourly: [HourlyForecastModel]
    let daily: [DailyForecastModel]
}

struct HourlyForecastModel {
    let date: Date
    let temperature: Double
    let description: String
    let icon: String
}

struct DailyForecastModel {
    let date: Date
    let icon: String
    let temperature: Double
}


enum ResponseConverter {
    static func parse(forecast: ForecastWeatherResponse) -> ForecastWeatherModel {
        let hourlyForecastModels = forecast.data.map {
            HourlyForecastModel(
                date: Date(timeIntervalSince1970: TimeInterval($0.dateTimeUnix)),
                temperature: $0.main.temp,
                description: $0.conditions.first?.description ?? "",//InvalidReference.undefined,
                icon: $0.conditions.first!.icon
            )
        }
        
        let dailyForecastModels = groupAndFilterOutTodayDate(forecast: forecast)
        let forecastWeatherModel = ForecastWeatherModel(
            hourly: hourlyForecastModels,
            daily: dailyForecastModels
        )
        
        return forecastWeatherModel
    }
    
    private static func groupAndFilterOutTodayDate(forecast: ForecastWeatherResponse) -> [DailyForecastModel] {
        let model = Dictionary(grouping: forecast.data, by: {
            Calendar.current.startOfDay(for: Date(timeIntervalSince1970: TimeInterval($0.dateTimeUnix)))
        })
            .compactMapValues({ $0.sorted(by: { $0.main.temp > $1.main.temp }) })
            .compactMap { $0.value.first }
            .filter {
                let date = Date(timeIntervalSince1970: TimeInterval($0.dateTimeUnix))
                    .formatted(date: .numeric, time: .omitted)
                let today = Date.now.formatted(date: .numeric, time: .omitted)
                return date != today
            }
            .sorted(by: { $0.dateTimeUnix < $1.dateTimeUnix })
        
        let result = model.map {
            DailyForecastModel(
                date: Date(timeIntervalSince1970: TimeInterval($0.dateTimeUnix)),
                icon: $0.conditions.first!.icon,
                temperature: $0.main.temp
            )
        }
        
        return result
    }
}
