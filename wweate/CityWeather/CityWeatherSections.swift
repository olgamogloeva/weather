//
//  CityWeatherSections.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit
enum HeaderType {
    case todayWeatherInfo(TodayWeatherView.Model)
}

struct HourForecastSectionModel {
    
    let id: String
    var items: [CityWeatherScreenItem]
    
    var headerModel: TodayWeatherView.Model
    
    var header: HeaderType? {
        .todayWeatherInfo(headerModel)
    }
}

struct WeekForecastSectionModel {
    
    let id: String
    var items: [CityWeatherScreenItem]
    
    
    var header: HeaderType? {
       nil
    }
}

enum CityWeatherSection {
    case hourForecast(HourForecastSectionModel)
    case weekForecast(WeekForecastSectionModel)
    
    var id: String {
        switch self {
        case .hourForecast(let model):
            return model.id
        case .weekForecast(let model):
            return model.id
        }
    }
    
    var header: HeaderType? {
        switch self {
        case .hourForecast(let model):
            return model.header
        case .weekForecast(let model):
            return model.header
        }
    }
    
    var items: [CityWeatherScreenItem] {
        switch self {
        case .hourForecast(let model):
            return model.items
        case .weekForecast(let model):
            return model.items
        }
    }
}

