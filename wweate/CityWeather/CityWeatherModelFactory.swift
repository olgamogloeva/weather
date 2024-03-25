//
//  CityWeatherModelFactory.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit

final class CityWeatherModelFactory {
     
    func createSections(
        currentWeather: CurrentWeatherResponse,
        forecast: ForecastWeatherResponse
    ) -> [CityWeatherSection] {
        var sections = [CityWeatherSection]()
        let wetherModel = ResponseConverter.parse(forecast: forecast)
        let hourForecastSectionModel = HourForecastSectionModel(
            id: "HourForecastSectionModel",
            items: makeHours(from: wetherModel.hourly),
            headerModel: makeTodayWeatherModel(from: currentWeather)
        )
        
        sections.append(.hourForecast(hourForecastSectionModel))
        let weekForecastSectionModel = WeekForecastSectionModel(
            id: "WeekForecastSectionModel",
            items: makeDays(from: wetherModel.daily)
        )
        sections.append(.weekForecast(weekForecastSectionModel))
        
        return sections
    }
    
    // MARK: - Private
    
    private func makeTodayWeatherModel(
        from model: CurrentWeatherResponse
    ) -> TodayWeatherView.Model {
        var weatherConditions: [TodayWeatherView.Model.Conditions] = []
        
        weatherConditions.append(
            .init(
                image: UIImage(systemName: "sunrise.fill") ?? UIImage(),
                title: TimeUtils.timeIntervalSince1970ToString(int: model.metadata.sunrise)
            )
        )
        
        weatherConditions.append(
            .init(
                image: UIImage(systemName: "sunset.fill") ?? UIImage(),
                title: TimeUtils.timeIntervalSince1970ToString(int: model.metadata.sunset)
            )
        )
        
        weatherConditions.append(
            .init(
                image: UIImage(systemName: "wind") ?? UIImage(),
                title: "\(model.wind.speed) m/s"
            )
        )
        
        weatherConditions.append(
            .init(
                image: UIImage(systemName: "humidity.fill") ?? UIImage(),
                title: "\(model.main.humidity) %"
            )
        )
        
        weatherConditions.append(
            .init(
                image: UIImage(systemName: "cloud") ?? UIImage(),
                title: "\(model.cloudCoverage.all) %"
            )
        )
        
        return .init(
            city: model.name,
            temperature: .init(
                current: "\(Int(model.main.temp))" + "°C",
                min: "\(model.main.tempMin)",
                max: "\(model.main.tempMax)"
            ),
            condition: weatherConditions
        )
    }
    
    
    private func makeHours(from models: [HourlyForecastModel]) -> [CityWeatherScreenItem] {
        models.map {
            .hourWeather(
                HourWeatherView.Model(
                    date: TimeUtils.prettyString(from: $0.date, dateFormat: .dayWithShortMonthAndTime),
                    temperature: "\(Int($0.temperature)) °C",
                    description: $0.description,
                    icon: $0.icon
                )
            )
        }
    }
    
    private func makeDays(from models: [DailyForecastModel]) -> [CityWeatherScreenItem] {
        models.map {
            .dayWeather(
                DayWeatherView.Model(
                    date: TimeUtils.prettyString(from: $0.date, dateFormat: .dayWithShortMonthAndTime),
                    icon: $0.icon,
                    temperature: "\(Int($0.temperature)) °C"
                )
            )
        }
    }
    
    
}

