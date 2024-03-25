//
//  WeekForecastNetworkService.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import Foundation

protocol IWeekForecastNetworkService {
    func fetchForecast(coordinate: Coordinate, completion: @escaping (Result<ForecastWeatherResponse, any Error>) -> Void)
}

final class WeekForecastNetworkService {
    
    let network: Network
    
    init(network: Network) {
        self.network = network
    }
}

// MARK: - IWeekForecastNetworkService

extension WeekForecastNetworkService: IWeekForecastNetworkService {
    func fetchForecast(coordinate: Coordinate, completion: @escaping (Result<ForecastWeatherResponse, any Error>) -> Void) {
        
        var urlComponents = URLComponents(string: NetworkConstants.baseURL + NetworkConstants.weekForecast)
        
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

