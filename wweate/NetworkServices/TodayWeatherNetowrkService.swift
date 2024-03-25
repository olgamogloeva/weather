//
//  TodayWeatherNetowrkService.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import Foundation

protocol ITodayWeatherNetowrkService {
    func getWeather(coordinate: Coordinate, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> Void)
}

final class TodayWeatherNetowrkService {
    
    let network: Network
    
    init(network: Network) {
        self.network = network
    }
}

// MARK: - ITodayWeatherNetowrkService

extension TodayWeatherNetowrkService: ITodayWeatherNetowrkService {
    func getWeather(coordinate: Coordinate, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> Void) {
        var urlComponents = URLComponents(string: NetworkConstants.baseURL + NetworkConstants.todayWeather)
        urlComponents?.queryItems  = [
            URLQueryItem(name: "lat", value: String(coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(coordinate.longitude)),
            URLQueryItem(name: "appid", value: NetworkConstants.apiKey),
            URLQueryItem(name: "units", value: NetworkConstants.units),

        ]
        guard let url = urlComponents?.url?.absoluteURL else { return }
        network.fetchData(from: url, completion: completion)
    }
}

